import SwiftUI

struct SessionListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var viewModel: SessionViewModel // Используем EnvironmentObject
    
    var body: some View {
        NavigationView {
            sessionListContent
                .navigationTitle("Сессии")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddSessionView()) { // Убрали передачу viewModel
                            Image(systemName: "plus")
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

    // Основной контент списка сессий
    private var sessionListContent: some View {
        List {
            ForEach(viewModel.sessions, id: \.id) { session in
                sessionRow(session: session)
            }
            .onDelete(perform: viewModel.deleteSessions)
        }
    }

    // Отображение строки сессии
    private func sessionRow(session: Session) -> some View {
        NavigationLink(destination: SessionDetailView(session: session)) { // Убрали передачу viewModel
            VStack(alignment: .leading) {
                Text("Трек: \(session.track.name)")
                Text("Автомобиль: \(session.car.model)")
                Text("Дата: \(session.date.formatted(date: .abbreviated, time: .shortened))")
                Text("Лучшее время: \(viewModel.getLapTimes(for: session).min()?.time ?? 0, specifier: "%.2f") сек")
            }
        }
    }
}
