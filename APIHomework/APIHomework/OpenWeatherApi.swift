import Foundation

class WeatherAPI {
    private let apiKey = "12fd0b09d6e27ccc173aba46c4317933"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    // Общий метод для выполнения запроса
    private func performRequest<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Метод для получения текущей погоды
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "\(baseURL)/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        performRequest(urlString: urlString, completion: completion)
    }
    
    // Метод для получения прогноза на 3 дня
    func fetch3DayForecast(lat: Double, lon: Double, completion: @escaping (Result<[Forecast], Error>) -> Void) {
        let urlString = "\(baseURL)/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        performRequest(urlString: urlString) { (result: Result<ForecastResponse, Error>) in
            switch result {
            case .success(let forecastResponse):
                // Фильтр, чтобы оставить только прогноз на 3 дня
                let threeDayForecast = Array(forecastResponse.list.prefix(24)) // 24 элемента = 3 дня (8 элементов в день)
                completion(.success(threeDayForecast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Метод для получения исторических данных о погоде за последние 5 дней
    func fetchHistoricalWeather(lat: Double, lon: Double, timestamp: Int, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let currentDate = Date()
        let selectedDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.day], from: selectedDate, to: currentDate)
        
        guard let daysDifference = difference.day, daysDifference <= 5 else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Historical data is only available for the last 5 days"])))
            return
        }
        
        // Формируем URL для запроса исторических данных
        let urlString = "\(baseURL)/onecall/timemachine?lat=\(lat)&lon=\(lon)&dt=\(timestamp)&appid=\(apiKey)&units=metric"
        performRequest(urlString: urlString, completion: completion)
    }
    
    struct ForecastResponse: Codable {
        let list: [Forecast]
    }
}
