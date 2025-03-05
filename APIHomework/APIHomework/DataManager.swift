import Foundation

class WeatherDataManager {
    private let userDefaults = UserDefaults.standard
    private let key = "savedWeatherData"
    
    // Сохранение данных
    func saveWeatherData(_ data: WeatherData) throws {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: key)
        } catch {
            throw WeatherDataError.encodingFailed(error)
        }
    }
    
    // Загрузка данных
    func loadWeatherData() throws -> WeatherData {
        guard let savedData = userDefaults.data(forKey: key) else {
            throw WeatherDataError.noDataFound
        }
        
        do {
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: savedData)
            return decodedData
        } catch {
            throw WeatherDataError.decodingFailed(error)
        }
    }
    
    // Удаление данных
    func clearWeatherData() {
        userDefaults.removeObject(forKey: key)
    }
    
    // Ошибки
    enum WeatherDataError: Error {
        case noDataFound
        case encodingFailed(Error)
        case decodingFailed(Error)
        
        var localizedDescription: String {
            switch self {
            case .noDataFound:
                return "No saved weather data found."
            case .encodingFailed(let error):
                return "Failed to encode weather data: \(error.localizedDescription)"
            case .decodingFailed(let error):
                return "Failed to decode weather data: \(error.localizedDescription)"
            }
        }
    }
}
