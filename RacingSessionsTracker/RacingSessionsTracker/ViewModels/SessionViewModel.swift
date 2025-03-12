import Foundation
import CoreData
import SwiftUI

class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var showDeleteSuccessAlert = false
    @Published var weatherData: WeatherData? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private var context = CoreDataManager.shared.context
    
    func fetchSessions() {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        do {
            sessions = try context.fetch(request)
        } catch {
            print("Failed to fetch sessions: \(error)")
        }
    }
    
    // Получение погоды
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        
        WeatherService().fetchWeather(latitude: latitude, longitude: longitude) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                completion(result)
            }
        }
    }
    
    // Сохранение сессии
    func saveSession(
        track: TrackData,
        carModel: String,
        horsepower: String,
        sessionDate: Date,
        lapTimes: [Double],
        weatherData: WeatherData
    ) -> Bool {
        
        let trackEntity = Track(context: context)
        trackEntity.id = UUID()
        trackEntity.name = track.name
        trackEntity.latitude = track.latitude
        trackEntity.longitude = track.longitude
        
        let carEntity = Car(context: context)
        carEntity.id = UUID()
        carEntity.model = carModel
        carEntity.horsepower = Int16(horsepower) ?? 0
        
        let weatherEntity = Weather(context: context)
        weatherEntity.id = UUID()
        weatherEntity.temperature = weatherData.main.temp
        weatherEntity.humidity = Double(weatherData.main.humidity)
        weatherEntity.descriptionText = weatherData.weather.first?.description ?? "Нет данных"
        
        let lapTimeObjects = lapTimes.map { lapTime in
            let lapTimeObject = LapTime(context: context)
            lapTimeObject.id = UUID()
            lapTimeObject.time = lapTime
            return lapTimeObject
        }
        
        let session = Session(context: context)
        session.id = UUID()
        session.date = sessionDate
        session.track = trackEntity
        session.car = carEntity
        session.weather = weatherEntity
        session.lapTimes = NSSet(array: lapTimeObjects)
        
        do {
            try context.save()
            return true
        } catch {
            print("Ошибка при сохранении сессии: \(error)")
            errorMessage = "Ошибка при сохранении сессии"
            return false
        }
    }
    
    // Форматирование времени в минуты и секунды
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func deleteSessions(at offsets: IndexSet) {
        offsets.forEach { index in
            let session = sessions[index]
            context.delete(session)
        }
        do {
            try context.save()
            showDeleteSuccessAlert = true
            fetchSessions() // Обновляем список сессий после удаления
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
