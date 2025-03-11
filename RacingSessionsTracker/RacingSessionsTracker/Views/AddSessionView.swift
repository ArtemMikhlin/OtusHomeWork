import SwiftUI

struct AddSessionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedTrack: TrackData? = nil
    @State private var carModel = ""
    @State private var horsepower = ""
    @State private var lapTimes: [Double] = []
    @State private var weatherData: WeatherData? = nil
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var sessionDate = Date()
    
    // Для кастомного пикера
    @State private var isAddingLapTime = false
    @State private var currentLapMinutes = 0
    @State private var currentLapSeconds = 0
    
    var body: some View {
        Form {
            Section(header: Text("Выберите трассу")) {
                Picker("Трасса", selection: $selectedTrack) {
                    Text("Не выбрано").tag(nil as TrackData?)
                    ForEach(TrackData.districts, id: \.self) { track in
                        Text(track.name).tag(track as TrackData?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                if let selectedTrack = selectedTrack {
                    AsyncImage(url: URL(string: selectedTrack.imageURL)) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 200)
                }
            }
            
            Section(header: Text("Автомобиль")) {
                TextField("Модель автомобиля", text: $carModel)
                TextField("Мощность (л/с)", text: $horsepower)
                    .keyboardType(.numberPad)
                    .onChange(of: horsepower) { oldValue, newValue in
                        horsepower = newValue.filter { $0.isNumber }
                    }
            }
            
            Section(header: Text("Дата и время сессии")) {
                DatePicker("Дата и время", selection: $sessionDate, displayedComponents: [.date, .hourAndMinute])
            }
            
            Section(header: Text("Время кругов")) {
                ForEach(lapTimes.indices, id: \.self) { index in
                    HStack {
                        Text("Круг \(index + 1):")
                        Spacer()
                        Text("\(formatTime(lapTimes[index]))")
                    }
                }
                
                if isAddingLapTime {
                    TimePickerView(minutes: $currentLapMinutes, seconds: $currentLapSeconds)
                    
                    Button("Сохранить круг") {
                        let lapTime = Double(currentLapMinutes * 60 + currentLapSeconds)
                        lapTimes.append(lapTime)
                        isAddingLapTime = false
                        currentLapMinutes = 0
                        currentLapSeconds = 0
                    }
                } else {
                    Button("Добавить круг") {
                        isAddingLapTime = true
                    }
                }
            }
            
            Section(header: Text("Погода")) {
                if isLoading {
                    ProgressView()
                } else if let weatherData = weatherData {
                    Text("Температура: \(weatherData.main.temp, specifier: "%.1f")°C")
                    Text("Влажность: \(weatherData.main.humidity, specifier: "%.1f")%")
                    Text("Описание: \(weatherData.weather.first?.description ?? "Нет данных")")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
                
                Button("Получить погоду") {
                    fetchWeather()
                }
                .disabled(selectedTrack == nil || isLoading)
            }
            
            Section {
                Button("Сохранить сессию") {
                    saveSession()
                }
                .disabled(selectedTrack == nil || carModel.isEmpty || horsepower.isEmpty || weatherData == nil || lapTimes.isEmpty)
            }
        }
        .navigationTitle("Новая сессия")
    }
    
    // Форматирование времени в минуты и секунды
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func fetchWeather() {
        guard let selectedTrack = selectedTrack else { return }
        
        isLoading = true
        errorMessage = nil
        
        WeatherService().fetchWeather(latitude: selectedTrack.latitude, longitude: selectedTrack.longitude) { result in
            isLoading = false
            
            switch result {
            case .success(let weatherData):
                self.weatherData = weatherData
            case .failure(let error):
                self.errorMessage = "Ошибка: \(error.localizedDescription)"
            }
        }
    }

    
    private func saveSession() {
        guard let selectedTrack = selectedTrack,
              let weatherData = weatherData else { return }
        
        // Проверяем, что все круги имеют ненулевое время
        guard !lapTimes.isEmpty, lapTimes.allSatisfy({ $0 > 0 }) else {
            errorMessage = "Время кругов не может быть пустым или нулевым"
            return
        }
        
        let track = Track(context: viewContext)
        track.id = UUID()
        track.name = selectedTrack.name
        track.latitude = selectedTrack.latitude
        track.longitude = selectedTrack.longitude
        
        let car = Car(context: viewContext)
        car.id = UUID()
        car.model = carModel
        car.horsepower = Int16(horsepower) ?? 0
        
        let weather = Weather(context: viewContext)
        weather.id = UUID()
        weather.temperature = weatherData.main.temp
        weather.humidity = Double(weatherData.main.humidity)
        weather.descriptionText = weatherData.weather.first?.description ?? "Нет данных"
        
        let lapTimeObjects = lapTimes.map { lapTime in
            let lapTimeObject = LapTime(context: viewContext)
            lapTimeObject.id = UUID()
            lapTimeObject.time = lapTime
            return lapTimeObject
        }
        
        let session = Session(context: viewContext)
        session.id = UUID()
        session.date = sessionDate
        session.track = track
        session.car = car
        session.weather = weather
        session.lapTimes = NSSet(array: lapTimeObjects)
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Ошибка при сохранении сессии: \(error)")
        }
    }
}
