import SwiftUI
import CoreData

struct SessionListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Session.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: false)]
    ) var sessions: FetchedResults<Session>

    var body: some View {
        NavigationView {
            List {
                ForEach(sessions, id: \.id) { session in
                    NavigationLink(destination: SessionDetailView(session: session)) {
                        VStack(alignment: .leading) {
                            if let track = session.track as? Track {
                                Text("Трек: \(track.name)")
                            }
                            if let car = session.car as? Car {
                                Text("Автомобиль: \(car.model)")
                            }
                            Text("Лучшее время: \(session.lapTimes.compactMap { ($0 as? LapTime)?.time }.min() ?? 0, specifier: "%.2f") сек")
                        }
                    }
                }
                .onDelete(perform: deleteSession)
            }
            .navigationTitle("Сессии")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Добавить тестовую сессию") {
                        let viewModel = SessionViewModel()
                        viewModel.addTestSession()
                    }
                }
            }
        }
    }

    private func deleteSession(at offsets: IndexSet) {
        offsets.forEach { index in
            let session = sessions[index]
            viewContext.delete(session)
        }
        do {
            try viewContext.save()
        } catch {
            print("Ошибка при удалении сессии: \(error)")
        }
    }
}
