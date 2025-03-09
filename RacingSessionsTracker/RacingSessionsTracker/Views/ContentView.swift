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
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                withAnimation {
                                    isMenuOpen.toggle()
                                }
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .imageScale(.large)
                            }
                        }
                    }
                
                // Боковое меню
                if isMenuOpen {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isMenuOpen.toggle()
                            }
                        }
                    
                    SideMenuView(navigationPath: $navigationPath, isMenuOpen: $isMenuOpen)
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                        .transition(.move(edge: .leading))
                        .background(Color.white)
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
}
