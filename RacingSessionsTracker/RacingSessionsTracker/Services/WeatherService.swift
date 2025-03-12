import Foundation

class WeatherService {
    private let apiKey = "12fd0b09d6e27ccc173aba46c4317933"
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
        case serverError(statusCode: Int)
        case unknownError
    }
    
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.unknownError))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}

struct WeatherData: Codable {
    let main: Main
    let weather: [WeatherInfo]
}

struct Main: Codable {
    let temp: Double
    let humidity: Double
}

struct WeatherInfo: Codable {
    let description: String
}
