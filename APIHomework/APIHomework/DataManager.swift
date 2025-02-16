import Foundation

class WeatherDataManager {
    private let userDefaults = UserDefaults.standard
    private let key = "savedWeatherData"
    
    func saveWeatherData(_ data: WeatherData) {
        if let encodedData = try? JSONEncoder().encode(data) {
            userDefaults.set(encodedData, forKey: key)
        }
    }
    
    func loadWeatherData() -> WeatherData? {
        if let savedData = userDefaults.data(forKey: key),
           let decodedData = try? JSONDecoder().decode(WeatherData.self, from: savedData) {
            return decodedData
        }
        return nil
    }
}
