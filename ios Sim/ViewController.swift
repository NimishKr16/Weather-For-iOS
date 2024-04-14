import UIKit

class ViewController: UIViewController {

    // UI Elements
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter City"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = "Humidity: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fetch Weather", for: .normal)
        button.addTarget(self, action: #selector(fetchWeatherData), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(cityLabel)
        view.addSubview(cityTextField)
        view.addSubview(temperatureLabel)
        view.addSubview(humidityLabel)
        view.addSubview(fetchButton)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            cityTextField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            cityTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityTextField.widthAnchor.constraint(equalToConstant: 200),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            humidityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            humidityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            fetchButton.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 20),
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func fetchWeatherData() {
        guard let city = cityTextField.text, !city.isEmpty else {
            // Show an alert or handle empty city name
            return
        }
        
        let apiKey = "e43be60e26d4423ebea102647241104" // Replace with your WeatherAPI.com API
        let urlString = "https://api.weatherapi.com/v1/current.json?key=e43be60e26d4423ebea102647241104&q=\(city)&aqi=no"
        
        guard let url = URL(string: urlString) else {
            // Show an alert or handle invalid URL
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        if let current = weatherResponse.current {
                            self.temperatureLabel.text = "Temperature: \(current.temp_c) °C"
                            self.humidityLabel.text = "Humidity: \(current.humidity)%"
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
}

struct WeatherResponse: Codable {
    let current: Current?
}

struct Current: Codable {
    let temp_c: Double
    let humidity: Int
}
