import SwiftUI

struct AddSessionView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var trackName = ""
    @State private var carModel = ""
    @State private var horsepower = ""
    @State private var temperature = ""
    @State private var humidity = ""
    @State private var weatherDescription = ""
    @State private var lapTimes: [Double] = []
    @State private var media: [Media] = []
    
    var body: some View {
        Form {
            Section(header: Text("Трек")) {
                TextField("Название трека", text: $trackName)
            }
            
            Section(header: Text("Автомобиль")) {
                TextField("Модель автомобиля", text: $carModel)
                TextField("Мощность (л/с)", text: $horsepower)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Погода")) {
                TextField("Температура (°C)", text: $temperature)
                    .keyboardType(.decimalPad)
                TextField("Влажность (%)", text: $humidity)
                    .keyboardType(.decimalPad)
                TextField("Описание погоды", text: $weatherDescription)
            }
            
            Section(header: Text("Время кругов")) {
                ForEach(lapTimes.indices, id: \.self) { index in
                    TextField("Круг \(index + 1)", value: $lapTimes[index], formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
                Button("Добавить круг") {
                    lapTimes.append(0.0)
                }
            }
            
            Section(header: Text("Медиа")) {
                Button("Добавить фото/видео") {
                    // Интеграция с галереей
                }
            }
            
            Section {
                Button("Сохранить сессию") {
                    saveSession()
                }
            }
        }
        .navigationTitle("Новая сессия")
    }
    
    private func saveSession() {
        let track = Track(context: CoreDataManager.shared.context)
        track.id = UUID()
        track.name = trackName
        track.latitude = 0.0 // Пример координат
        track.longitude = 0.0
        
        let car = Car(context: CoreDataManager.shared.context)
        car.id = UUID()
        car.model = carModel
        car.horsepower = Int16(horsepower) ?? 0
        
        let weather = Weather(context: CoreDataManager.shared.context)
        weather.id = UUID()
        weather.temperature = Double(temperature) ?? 0.0
        weather.humidity = Double(humidity) ?? 0.0
        weather.descriptionText = weatherDescription
        
        let lapTimeObjects = lapTimes.map { lapTime in
            let lapTimeObject = LapTime(context: CoreDataManager.shared.context)
            lapTimeObject.id = UUID()
            lapTimeObject.time = lapTime
            return lapTimeObject
        }
        
        viewModel.addSession(track: track, car: car, weather: weather, lapTimes: lapTimeObjects, media: media)
    }
}
