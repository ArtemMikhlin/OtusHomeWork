import Foundation

// Модель текущей погоды
struct WeatherData: Codable {
    let main: Main
    let dt: Int
    let name: String
    let rain: Rain?
}

// Модель прогноза погоды
struct ForecastResponse: Codable {
    let list: [Forecast]
}

// Модель одного элемента прогноза
struct Forecast: Codable {
    let dt: Int // Время прогноза (Unix timestamp)
    let main: Main
    let weather: [Weather]
    let rain: Rain?
}

// Общая структура данных
struct Main: Codable {
    let temp: Double
    let humidity: Int
}

// Структура описания погоды
struct Weather: Codable {
    let description: String
}

// Структура данных об осадках
struct Rain: Codable {
    let lastHour: Double?
    let last3Hours: Double?
    
    enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
        case last3Hours = "3h"
    }
}
