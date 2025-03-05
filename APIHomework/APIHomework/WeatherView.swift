import UIKit

class WeatherView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource {
    @IBOutlet weak var districtPicker: UIPickerView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!

    // Dependencies
    var weatherAPI: WeatherAPI!
    var weatherDataManager: WeatherDataManager!
    var districts: [String: (lat: Double, lon: Double, imageURL: String)]!

    // Selected location
    private var selectedDistrict: String = "ЦТВС"
    private var forecastData: [Forecast] = []

    // MARK: - Initialization

    // Initializer for Storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("WeatherView initialized via Storyboard")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")

        // Check if dependencies are set
        guard weatherAPI != nil, weatherDataManager != nil, districts != nil else {
            fatalError("Dependencies not set! Set dependencies before using WeatherView.")
        }

        // Setup PickerView
        districtPicker.dataSource = self
        districtPicker.delegate = self

        // Setup TableView
        forecastTableView.dataSource = self
        forecastTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ForecastCell")

        // Setup DatePicker
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .dateAndTime

        // Load initial data
        if let initialIndex = Array(districts.keys).firstIndex(of: selectedDistrict) {
            districtPicker.selectRow(initialIndex, inComponent: 0, animated: false)
        }

        // Load image for the initial location
        if let imageURL = districts[selectedDistrict]?.imageURL {
            ImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
                self?.weatherImageView.image = image
            }
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

        // Load image for the selected location
        if let imageURL = districts[selectedDistrict]?.imageURL {
            ImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
                self?.weatherImageView.image = image
            }
        } else {
            weatherImageView.image = nil
        }

        // Update forecast data
        fetchWeather()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
        let forecast = forecastData[indexPath.row]

        // Format date
        let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM|HH:mm"
        let dateString = dateFormatter.string(from: date)

        // Format weather data
        let temp = String(format: "%.1f°C", forecast.main.temp)
        let description = forecast.weather.first?.description ?? "No data received"

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

        if Calendar.current.isDateInToday(selectedDate) {
            weatherAPI.fetchCurrentWeather(lat: coordinates.lat, lon: coordinates.lon) { result in
                DispatchQueue.main.async {
                    self.handleCurrentWeatherResult(result)
                }
            }

            weatherAPI.fetch3DayForecast(lat: coordinates.lat, lon: coordinates.lon) { result in
                DispatchQueue.main.async {
                    self.handleForecastResult(result)
                }
            }
        } else {
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

            // Save data with error handling
            do {
                try self.weatherDataManager.saveWeatherData(weatherData)
                print("Weather data saved successfully.")
            } catch {
                print("Failed to save weather data: \(error.localizedDescription)")
            }

        case .failure(let error):
            self.errorLabel.text = "Error: \(error.localizedDescription)"
            self.errorLabel.numberOfLines = 0
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
