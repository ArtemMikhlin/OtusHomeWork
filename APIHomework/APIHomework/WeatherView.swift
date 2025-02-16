import UIKit

class WeatherView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var districtPicker: UIPickerView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Properties
    private let weatherAPI = WeatherAPI()
    private let weatherDataManager = WeatherDataManager()
    
    private let districts = [
        "Mayak 1.0": (lat: 56.1008, lon: 37.3054),
        "ЦТВС": (lat: 55.3914, lon: 37.4034),
        "ADM": (lat: 55.5647, lon: 37.9896),
        "Ижорец": (lat: 59.7594, lon: 30.6062),
        "Сириус": (lat: 43.4009, lon: 39.9524),
        "Max Motors Sochi": (lat: 43.6668, lon: 39.7605),
    ]
    
    private var selectedDistrict: String = "ЦТВС"
    private var forecastData: [Forecast] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка PickerView
        districtPicker.dataSource = self
        districtPicker.delegate = self
        
        // Настройка TableView
        forecastTableView.dataSource = self
        forecastTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ForecastCell")
        
        // Настройка DatePicker 
        // (Отображаеся ошибка так как исторические данные досупны ток в платной версии)
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .dateAndTime
        
        // Загрузка начальных данных
        if let initialIndex = Array(districts.keys).firstIndex(of: selectedDistrict) {
            districtPicker.selectRow(initialIndex, inComponent: 0, animated: false)
        }
        
        fetchWeather()
    }
    
    // MARK: - Actions
    @IBAction func fetchWeatherButtonTapped(_ sender: UIButton) {
        fetchWeather()
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return districts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(districts.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDistrict = Array(districts.keys)[row]
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
        let forecast = forecastData[indexPath.row]
        
        // Форматируем дату
        let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM|HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        // Форматируем данные о погоде
        let temp = String(format: "%.1f°C", forecast.main.temp)
        let description = forecast.weather.first?.description ?? "No data received"
        let rain = forecast.rain?.last3Hours ?? 0
        
        cell.textLabel?.text = "\(dateString): \(temp), \(description)"
        return cell
    }
    
    // MARK: - Private Methods
    private func fetchWeather() {
        guard let coordinates = districts[selectedDistrict] else {
            errorLabel.text = "District not found"
            return
        }
        
        let selectedDate = datePicker.date
        let timestamp = Int(selectedDate.timeIntervalSince1970)
        
        // Проверяем, выбрана ли текущая дата или дата в прошлом
        if Calendar.current.isDateInToday(selectedDate) {
            // Получаем текущую погоду
            weatherAPI.fetchCurrentWeather(lat: coordinates.lat, lon: coordinates.lon) { result in
                DispatchQueue.main.async {
                    self.handleCurrentWeatherResult(result)
                }
            }
            
            // Получаем прогноз на 3 дня
            weatherAPI.fetch3DayForecast(lat: coordinates.lat, lon: coordinates.lon) { result in
                DispatchQueue.main.async {
                    self.handleForecastResult(result)
                }
            }
        } else {
            // Получаем исторические данные
            weatherAPI.fetchHistoricalWeather(lat: coordinates.lat, lon: coordinates.lon, timestamp: timestamp) { result in
                DispatchQueue.main.async {
                    self.handleCurrentWeatherResult(result)
                }
            }
        }
    }
    
    private func handleCurrentWeatherResult(_ result: Result<WeatherData, Error>) {
        switch result {
        case .success(let weatherData):
            self.temperatureLabel.text = String(format: "Temperature: %.1f°C", weatherData.main.temp)
            self.humidityLabel.text = "Humidity: \(weatherData.main.humidity)%"
            
            if let rain = weatherData.rain?.lastHour {
                self.rainLabel.text = self.getRainDescription(rain: rain)
            } else {
                self.rainLabel.text = "Precipitation: No"
            }
            
            self.errorLabel.text = ""
            self.weatherDataManager.saveWeatherData(weatherData)
        case .failure(let error):
            self.errorLabel.text = "Error: \(error.localizedDescription)"
            self.errorLabel.numberOfLines = 0 // Разрешаем несколько строк
            self.errorLabel.lineBreakMode = .byWordWrapping
            self.temperatureLabel.text = ""
            self.humidityLabel.text = ""
            self.rainLabel.text = ""
        }
    }
    
    private func handleForecastResult(_ result: Result<[Forecast], Error>) {
        switch result {
        case .success(let forecast):
            self.forecastData = forecast
            self.forecastTableView.reloadData()
        case .failure(let error):
            self.errorLabel.text = "Error getting forecast: \(error.localizedDescription)"
        }
    }
    
    private func getRainDescription(rain: Double) -> String {
        switch rain {
        case 0:
            return "Precipitation: No"
        case 0.1..<2.6:
            return String(format: "Light rain: %.1f mm", rain)
        case 2.6..<7.6:
            return String(format: "Moderate rain: %.1f mm", rain)
        default:
            return String(format: "Heavy rain: %.1f mm", rain)
        }
    }
}
