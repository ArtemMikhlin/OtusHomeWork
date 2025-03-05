import Foundation

class DependencyContainer {
    let weatherAPI: WeatherAPI
    let weatherDataManager: WeatherDataManager
    let districts: [String: (lat: Double, lon: Double, imageURL: String)]

    init() {
        self.weatherAPI = WeatherAPIBuilder()
            .setAPIKey("12fd0b09d6e27ccc173aba46c4317933")
            .setBaseURL("https://api.openweathermap.org/data/2.5")
            .build()
        
        self.weatherDataManager = WeatherDataManager()
        
        self.districts = [
            "Mayak 1.0": (lat: 56.1008, lon: 37.3054, imageURL: "https://kudamoscow.ru/uploads/46953de5d570138e2179cf7deefbee31.jpg"),
            "ЦТВС": (lat: 55.3914, lon: 37.4034, imageURL: "https://avatars.mds.yandex.net/get-altay/2356223/2a0000017328e3fc4533f2b5308ff71ae238/L_height"),
            "ADM": (lat: 55.5647, lon: 37.9896, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmkv6e9SEjZ8ccm7Sx4RDsjtO7Nuah1Cdg&s"),
            "Ижорец": (lat: 59.7594, lon: 30.6062, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoUQO6gWvSeAxdclDL-wIDjI4VNGksYOLh7A&s"),
            "Сириус": (lat: 43.4009, lon: 39.9524, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQB4yXPRr1G7onxUXrsuxCSmFCWuyeAZnnHgQ&s"),
            "Max Motors Sochi": (lat: 43.6668, lon: 39.7605, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgmTI_QLF2cYBHgsJxzjV9tbmTdSPM9n8Q3g&s"),
        ]
    }
}
