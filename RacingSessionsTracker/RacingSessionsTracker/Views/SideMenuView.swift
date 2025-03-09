import SwiftUI

struct SideMenuView: View {
    @Binding var navigationPath: NavigationPath
    @Binding var isMenuOpen: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Кнопки для навигации
            Button(action: {
                navigationPath.append("SessionListView")
                isMenuOpen = false
            }) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("Список сессий")
                }
                .foregroundColor(.black)
                .font(.headline)
            }
            
            Button(action: {
                navigationPath.append("AddSessionView")
                isMenuOpen = false
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Добавить сессию")
                }
                .foregroundColor(.black)
                .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
    }
}
