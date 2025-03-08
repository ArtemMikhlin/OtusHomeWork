import Foundation
import CoreData
import SwiftUI

class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    private var context = CoreDataManager.shared.context
    
    func fetchSessions() {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        do {
            sessions = try context.fetch(request)
        } catch {
            print("Failed to fetch sessions: \(error)")
        }
    }
    
    func addSession(track: Track, car: Car, weather: Weather, lapTimes: [LapTime], media: [Media]) {
        let newSession = Session(context: context)
        newSession.id = UUID()
        newSession.date = Date()
        newSession.track = track
        newSession.car = car
        newSession.weather = weather
        
        // Преобразуем [LapTime] в NSSet
        newSession.lapTimes = NSSet(array: lapTimes)
        
        // Преобразуем [Media] в NSSet
        newSession.media = NSSet(array: media)
        
        CoreDataManager.shared.saveContext()
        fetchSessions()
    }
    
    func deleteSession(_ session: Session) {
        context.delete(session)
        CoreDataManager.shared.saveContext()
        fetchSessions()
    }
    
    // Функция для получения Set<LapTime> из Session
    func getLapTimes(for session: Session) -> Set<LapTime> {
        return session.lapTimes as? Set<LapTime> ?? []
    }
    
    // Функция для получения Set<Media> из Session
    func getMedia(for session: Session) -> Set<Media> {
        return session.media as? Set<Media> ?? []
    }
    
    func addTestSession() {
        let track = Track(context: CoreDataManager.shared.context)
        track.id = UUID()
        track.name = "Monza"
        track.latitude = 45.6156
        track.longitude = 9.2811

        let car = Car(context: CoreDataManager.shared.context)
        car.id = UUID()
        car.model = "Kart"
        car.horsepower = 15

        let weather = Weather(context: CoreDataManager.shared.context)
        weather.id = UUID()
        weather.temperature = 25.0
        weather.humidity = 60.0
        weather.descriptionText = "Sunny"

        let lapTime1 = LapTime(context: CoreDataManager.shared.context)
        lapTime1.id = UUID()
        lapTime1.time = 45.3

        let lapTime2 = LapTime(context: CoreDataManager.shared.context)
        lapTime2.id = UUID()
        lapTime2.time = 44.8

        let media = Media(context: CoreDataManager.shared.context)
        media.id = UUID()
        media.filePath = "path/to/media"

        addSession(track: track, car: car, weather: weather, lapTimes: [lapTime1, lapTime2], media: [media])
    }
}
