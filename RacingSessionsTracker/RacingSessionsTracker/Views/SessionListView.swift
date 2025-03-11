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
                .onDelete(perform: deleteSession)
            }
            .navigationTitle("Сессии")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddSessionView()) {
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

    private func deleteSession(at offsets: IndexSet) {
        offsets.forEach { index in
            let session = viewModel.sessions[index]
            viewModel.deleteSession(session)
        }
    }
}
