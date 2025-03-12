import SwiftUI

struct AddSessionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var viewModel: SessionViewModel
    
    @State private var selectedTrack: TrackData? = nil
    @State private var carModel = ""
    @State private var horsepower = ""
    @State private var lapTimes: [Double] = []
    @State private var sessionDate = Date()
    
    // Для кастомного пикера
    @State private var isAddingLapTime = false
    @State private var currentLapMinutes = 0
    @State private var currentLapSeconds = 0
    
    // Для отображения ошибки
    @State private var lapTimeError: String? = nil
    
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
                        Text("\(viewModel.formatTime(lapTimes[index]))")
                    }
                }
                
                if isAddingLapTime {
                    TimePickerView(minutes: $currentLapMinutes, seconds: $currentLapSeconds)
                    
                    if let lapTimeError = lapTimeError {
                        Text(lapTimeError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button("Сохранить круг") {
                        let lapTime = Double(currentLapMinutes * 60 + currentLapSeconds)
                        
                        // Проверяем, что время круга не равно нулю
                        if lapTime > 0 {
                            lapTimes.append(lapTime)
                            isAddingLapTime = false
                            currentLapMinutes = 0
                            currentLapSeconds = 0
                            lapTimeError = nil
                        } else {
                            lapTimeError = "Введите время круга"
                        }
                    }
                } else {
                    Button("Добавить круг") {
                        isAddingLapTime = true
                        lapTimeError = nil // Сбрасываем ошибку при открытии пикера
                    }
                }
            }
            
            Section(header: Text("Погода")) {
                if viewModel.isLoading {
                    ProgressView()
                } else if let weatherData = viewModel.weatherData {
                    Text("Температура: \(weatherData.main.temp, specifier: "%.1f")°C")
                    Text("Влажность: \(weatherData.main.humidity, specifier: "%.1f")%")
                    Text("Описание: \(weatherData.weather.first?.description ?? "Нет данных")")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
                
                Button("Получить погоду") {
                    if let selectedTrack = selectedTrack {
                        viewModel.fetchWeather(latitude: selectedTrack.latitude, longitude: selectedTrack.longitude) { result in
                            switch result {
                            case .success(let weatherData):
                                self.viewModel.weatherData = weatherData
                            case .failure(let error):
                                self.viewModel.errorMessage = "Ошибка: \(error.localizedDescription)"
                            }
                        }
                    }
                }
                .disabled(selectedTrack == nil || viewModel.isLoading)
            }
            
            Section {
                Button("Сохранить сессию") {
                    if let selectedTrack = selectedTrack,
                       let weatherData = viewModel.weatherData {
                        let success = viewModel.saveSession(
                            track: selectedTrack,
                            carModel: carModel,
                            horsepower: horsepower,
                            sessionDate: sessionDate,
                            lapTimes: lapTimes,
                            weatherData: weatherData
                        )
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .disabled(selectedTrack == nil || carModel.isEmpty || horsepower.isEmpty || viewModel.weatherData == nil || lapTimes.isEmpty)
            }
        }
        .navigationTitle("Новая сессия")
    }
}
