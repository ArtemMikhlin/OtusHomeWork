import Foundation
import CoreData
import SwiftUI

class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var showDeleteSuccessAlert = false
    
    private var context = CoreDataManager.shared.context
    
    func fetchSessions() {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        do {
            sessions = try context.fetch(request)
        } catch {
            print("Failed to fetch sessions: \(error)")
        }
    }
    
    func deleteSession(_ session: Session) {
        context.delete(session)
        do {
            try context.save()
            fetchSessions() // Обновляем список сессий
            showDeleteSuccessAlert = true // Показываем уведомление
        } catch {
            print("Ошибка при удалении сессии: \(error)")
        }
    }
    
    func getLapTimes(for session: Session) -> Set<LapTime> {
        return session.lapTimes as? Set<LapTime> ?? []
    }
    
    func getMedia(for session: Session) -> Set<Media> {
        return session.media as? Set<Media> ?? []
    }
}
