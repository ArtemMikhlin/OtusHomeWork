class WeatherAPIBuilder {
    private var apiKey: String = ""
    private var baseURL: String = ""
    
    func setAPIKey(_ apiKey: String) -> WeatherAPIBuilder {
        self.apiKey = apiKey
        return self
    }
    
    func setBaseURL(_ baseURL: String) -> WeatherAPIBuilder {
        self.baseURL = baseURL
        return self
    }
    
    func build() -> WeatherAPI {
        return WeatherAPI(apiKey: apiKey, baseURL: baseURL)
    }
}
