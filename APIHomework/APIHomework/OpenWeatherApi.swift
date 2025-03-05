import Foundation

class WeatherAPI {
    private let apiKey: String
    private let baseURL: String
    
    init(apiKey: String, baseURL: String) {
        self.apiKey = apiKey
        self.baseURL = baseURL
    }
    
    // Общий метод
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
    
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "\(baseURL)/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        performRequest(urlString: urlString, completion: completion)
    }
    
    func fetch3DayForecast(lat: Double, lon: Double, completion: @escaping (Result<[Forecast], Error>) -> Void) {
        let urlString = "\(baseURL)/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        performRequest(urlString: urlString) { (result: Result<ForecastResponse, Error>) in
            switch result {
            case .success(let forecastResponse):
                // Фильтр, прогноз на 3 дня
                let threeDayForecast = Array(forecastResponse.list.prefix(24)) // 24 элемента = 3 дня (8 элементов в день)
                completion(.success(threeDayForecast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

    func fetchHistoricalWeather(lat: Double, lon: Double, timestamp: Int, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let currentDate = Date()
        let selectedDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.day], from: selectedDate, to: currentDate)
        
        guard let daysDifference = difference.day, daysDifference <= 5 else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Historical data is only available for the last 5 days"])))
            return
        }
        
        let urlString = "\(baseURL)/onecall/timemachine?lat=\(lat)&lon=\(lon)&dt=\(timestamp)&appid=\(apiKey)&units=metric"
        performRequest(urlString: urlString, completion: completion)
    }
    
    struct ForecastResponse: Decodable {
        let list: [Forecast]
    }
}
