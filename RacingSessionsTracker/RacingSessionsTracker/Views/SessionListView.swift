import SwiftUI

struct SessionListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var viewModel = SessionViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sessions, id: \.id) { session in
                    NavigationLink(destination: SessionDetailView(session: session)) {
                        VStack(alignment: .leading) {
                            Text("Трек: \(session.track.name)")
                            Text("Автомобиль: \(session.car.model)")
                            Text("Дата: \(session.date.formatted(date: .abbreviated, time: .shortened))")
                            Text("Лучшее время: \(viewModel.getLapTimes(for: session).min()?.time ?? 0, specifier: "%.2f") сек")
                        }
                    }
                }
                .onDelete(perform: deleteSession) // Удаление через свайп
            }
            .navigationTitle("Сессии")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink(destination: AddSessionView()) {
                            Image(systemName: "plus")
                        }
                        Button(action: addTestSession) {
                            Image(systemName: "doc.badge.plus")
                        }
                    }
                }
            }
            .alert("Сессия удалена", isPresented: $viewModel.showDeleteSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Сессия успешно удалена.")
            }
            .onAppear {
                viewModel.fetchSessions()
            }
        }
    }

    // Удаление сессии
    private func deleteSession(at offsets: IndexSet) {
        offsets.forEach { index in
            let session = viewModel.sessions[index]
            viewModel.deleteSession(session)
        }
    }
    
    // Создание тестовой сессии
    private func addTestSession() {
        let track = Track(context: viewContext)
        track.id = UUID()
        track.name = "Тестовый трек"
        track.latitude = 56.1008
        track.longitude = 37.3054
        
        let car = Car(context: viewContext)
        car.id = UUID()
        car.model = "Тестовый автомобиль"
        car.horsepower = 100
        
        let weather = Weather(context: viewContext)
        weather.id = UUID()
        weather.temperature = 20.0
        weather.humidity = 60.0
        weather.descriptionText = "Солнечно"
        
        let lapTime1 = LapTime(context: viewContext)
        lapTime1.id = UUID()
        lapTime1.time = 45.3
        
        let lapTime2 = LapTime(context: viewContext)
        lapTime2.id = UUID()
        lapTime2.time = 44.8
        
        let session = Session(context: viewContext)
        session.id = UUID()
        session.date = Date()
        session.track = track
        session.car = car
        session.weather = weather
        session.lapTimes = NSSet(array: [lapTime1, lapTime2])
        
        do {
            try viewContext.save()
        } catch {
            print("Ошибка при создании тестовой сессии: \(error)")
        }
    }
}
