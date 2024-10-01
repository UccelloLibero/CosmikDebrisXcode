//
//  WeatherData.swift
//  Prognoza
//
//  Created by Maya McPherson on 9/23/24.
//

import Foundation

// Model for the current weather and forecast
struct WeatherData: Codable {
    let currentTemp: String
    let description: String
    let forecastIcons: [String]
    let forecastTimes: [String]   // To store forecast times (3-hour intervals)
    let forecastTemps: [String]   // To store forecast temperatures
    let forecastDescriptions: [String] // To store forecast descriptions
}

class WeatherService {
    static var apiKey: String {
        // Ensure the Secrets.plist file exists and fetch the key
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path),
              let key = dictionary["OpenWeatherAPIKey"] as? String else {
            fatalError("API key not found in Secrets.plist")
        }
        return key
    }
    
    // Fetch weather data using OpenWeather API
    static func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                
                // Map OpenWeather response to WeatherData
                let weatherData = mapOpenWeatherResponseToWeatherData(response)
                DispatchQueue.main.async {
                    completion(weatherData)
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    // Helper function to map OpenWeather API response to WeatherData
    private static func mapOpenWeatherResponseToWeatherData(_ response: OpenWeatherResponse) -> WeatherData {
        let currentTemp = "\(response.list.first?.main.temp ?? 0)"
        let description = response.list.first?.weather.first?.description ?? "N/A"
        
        // Extract forecast data (first 5 items)
        let forecastIcons = response.list.prefix(5).compactMap { $0.weather.first?.icon }
        let forecastTimes = response.list.prefix(5).map { $0.dt_txt }  // Get the forecast time (3-hour intervals)
        let forecastTemps = response.list.prefix(5).map { "\($0.main.temp)" }
        let forecastDescriptions = response.list.prefix(5).map { $0.weather.first?.description ?? "N/A" }
        
        return WeatherData(
            currentTemp: currentTemp,
            description: description,
            forecastIcons: forecastIcons,
            forecastTimes: forecastTimes,
            forecastTemps: forecastTemps,
            forecastDescriptions: forecastDescriptions
        )
    }
    
    struct OpenWeatherResponse: Codable {
        let list: [Forecast]
        
        struct Forecast: Codable {
            let main: Main
            let weather: [Weather]
            let dt_txt: String  // Date-time text for the forecast
            
            struct Main: Codable {
                let temp: Double  // Forecast temperature
            }
            
            struct Weather: Codable {
                let description: String
                let icon: String
            }
        }
    }
}
