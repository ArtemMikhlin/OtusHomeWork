import Foundation

class WeatherService {
    private let apiKey = "12fd0b09d6e27ccc173aba46c4317933"
    
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherData?) -> Void) {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        guard let url = components?.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                completion(weatherData)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

struct WeatherData: Codable {
    let main: Main
    let weather: [WeatherInfo]
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
    }
}

struct Main: Codable {
    let temp: Double
    let humidity: Double
}

struct WeatherInfo: Codable {
    let description: String
}
