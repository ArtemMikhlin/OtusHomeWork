import Foundation

struct WeatherData: Codable {
    let main: Main
    let dt: Int
    let name: String
    let rain: Rain?
    let wind: Wind
}

struct Forecast: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let rain: Rain?
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
}

struct Rain: Codable {
    let lastHour: Double?
    let last3Hours: Double?
    
    enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
        case last3Hours = "3h"
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int?
}
