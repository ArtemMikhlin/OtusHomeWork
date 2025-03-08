import SwiftUI

struct SessionDetailView: View {
    let session: Session
    @StateObject private var viewModel = SessionViewModel()
    
    var body: some View {
        List {
            Section(header: Text("Информация о сессии")) {
                Text("Трек: \(session.track.name)")
                Text("Автомобиль: \(session.car.model)")
                Text("Мощность: \(session.car.horsepower) л/с")
                Text("Погода: \(session.weather.descriptionText)")
                Text("Температура: \(session.weather.temperature, specifier: "%.1f")°C")
                Text("Влажность: \(session.weather.humidity, specifier: "%.1f")%")
            }
            
            Section(header: Text("Время кругов")) {
                ForEach(Array(viewModel.getLapTimes(for: session)), id: \.id) { lapTime in
                    Text("\(lapTime.time, specifier: "%.2f") сек")
                }
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
