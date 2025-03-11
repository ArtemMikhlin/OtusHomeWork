import SwiftUI

@main
struct RacingSessionsTrackerApp: App {
    let persistenceController = CoreDataManager.shared
    @StateObject private var viewModel = SessionViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context)
                .environmentObject(viewModel) // Добавляем viewModel в Environment
        }
    }
}
