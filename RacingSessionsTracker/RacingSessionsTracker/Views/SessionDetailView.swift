import SwiftUI

struct SessionDetailView: View {
    let session: Session
    @ObservedObject private var viewModel = SessionViewModel()
    
    var totalSessionTime: String {
        let totalSeconds = viewModel.getLapTimes(for: session).reduce(0) { $0 + $1.time }
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        return "\(minutes) мин \(seconds) сек"
    }
    
    var body: some View {
        List {
            Section(header: Text("Информация о сессии")) {
                Text("Трек: \(session.track.name)")
                Text("Автомобиль: \(session.car.model)")
                Text("Мощность: \(session.car.horsepower) л/с")
                Text("Дата: \(session.date.formatted(date: .abbreviated, time: .shortened))")
                Text("Погода: \(session.weather.descriptionText)")
                Text("Температура: \(session.weather.temperature, specifier: "%.1f")°C")
                Text("Влажность: \(session.weather.humidity, specifier: "%.1f")%")
            }
            
            Section(header: Text("Время кругов")) {
                ForEach(Array(viewModel.getLapTimes(for: session)), id: \.id) { lapTime in
                    Text("\(lapTime.time, specifier: "%.2f") сек")
                }
                Text("Общее время: \(totalSessionTime)")
            }
            
            Section(header: Text("Медиа")) {
                ForEach(Array(viewModel.getMedia(for: session)), id: \.id) { media in
                    if let url = URL(string: media.filePath) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 200)
                    }
                }
            }
        }
        .navigationTitle("Детали сессии")
    }
}
