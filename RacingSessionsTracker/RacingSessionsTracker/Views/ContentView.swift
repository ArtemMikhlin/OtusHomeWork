import SwiftUI

struct ContentView: View {
    @State private var isMenuOpen = false
    @State private var navigationPath = NavigationPath() // Для управления навигацией
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                // Основной контент
                SessionListView()
                    .navigationTitle("Главная")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        }
                    }
                
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "SessionListView":
                    SessionListView()
                case "AddSessionView":
                    AddSessionView()
                default:
                    EmptyView()
                }
            }
        }
    }
