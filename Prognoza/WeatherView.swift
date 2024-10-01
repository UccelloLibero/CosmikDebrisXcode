//
//  WeatherView.swift
//  Prognoza
//
//  Created by Maya McPherson on 9/23/24.
//

import SwiftUI

struct WeatherView: View {
    @State private var weatherData: WeatherData?
    @State private var backgroundColor: Color = Color(red: 1, green: 0.9804, blue: 0.9412) // Default background color
    let latitude: Double
    let longitude: Double
    let locationName: String  // Pass location name as a parameter

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 20) {
                // Title showing today's weather for the current location
                Text("\(locationName)")
                    .font(.largeTitle)
                    .foregroundColor(getTextColor()) // Use dynamic text color
                    .padding()

                // Current Temperature under location name
                if let weatherData = weatherData {
                    Text("\(Int(round(Double(weatherData.currentTemp) ?? 0)))°")
                        .font(.title)
                        .bold()
                        .foregroundColor(getTextColor()) // Use dynamic text color
                        .padding(.bottom, 20)

                    // Capitalized Weather description
                    Text(weatherData.description.capitalized)
                        .font(.title2)
                        .italic()
                        .foregroundColor(getTextColor()) // Use dynamic text color
                }

                if let weatherData = weatherData {
                    VStack(alignment: .leading, spacing: 20) {
                        // 5-day Forecast displayed in table format with day, icon, description, and temperature
                        ForEach(0..<min(weatherData.forecastIcons.count, 5), id: \.self) { index in
                            HStack {
                                // Day of the week
                                Text(getDayOfWeek(index: index))
                                    .font(.headline)
                                    .foregroundColor(getTextColor()) // Use dynamic text color
                                    .frame(width: 100, alignment: .leading)
                                
                                // Weather icon
                                Image(systemName: mapOpenWeatherIconToSystem(weatherData.forecastIcons[index]))
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(getIconColor(weatherData.forecastIcons[index])) // Dynamic icon color
                                    .padding(.horizontal, 10)

                                // Weather description
                                Text(weatherData.description.capitalized)
                                    .foregroundColor(getTextColor()) // Use dynamic text color
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                // Current temperature
                                Text("\(Int(round(Double(weatherData.currentTemp) ?? 0)))°")
                                    .bold()
                                    .foregroundColor(getTextColor()) // Dynamic text color
                                    .frame(width: 50, alignment: .trailing)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // Align everything to the left
                            .padding(.vertical, 8) // Add spacing between rows
                        }
                    }
                    .padding()
                }

                Spacer()
            }
            .onAppear {
                fetchWeather()
            }
        }
    }

    // Fetch weather data from the OpenWeather API
    func fetchWeather() {
        WeatherService.fetchWeather(latitude: latitude, longitude: longitude) { data in
            if let data = data {
                self.weatherData = data
                updateBackgroundColor()
            }
        }
    }

    // Update background color based on the time of day
    func updateBackgroundColor() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6...11:
            backgroundColor = Color(hex: "#B9DDF9")  // Daytime background
        case 12...17:
            backgroundColor = Color(hex: "#CACBCF")  // Evening background
        default:
            backgroundColor = Color(hex: "#212121")  // Night background
        }
    }

    // Dynamic text color based on the time of day
    func getTextColor() -> Color {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 18 || hour < 6 ? Color(hex: "#FBFCFF") : Color(hex: "#212121")
    }

    // Map OpenWeather icon codes to Apple's system SF Symbols
    func mapOpenWeatherIconToSystem(_ icon: String) -> String {
        switch icon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.stars.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.rain.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "questionmark.circle.fill"
        }
    }

    // Dynamic icon color based on weather condition
    func getIconColor(_ icon: String) -> Color {
        switch icon {
        case "01d": return Color(hex: "#FEDA15") // Sun color
        case "09d", "09n", "10d", "10n": return Color(hex: "#1264ab") // Rain color
        case "02d", "02n", "03d", "03n", "04d", "04n": return Color(hex: "#B0B5CB") // Cloud color
        default: return .gray // Default color
        }
    }

    // Helper function to get the day of the week based on index
    func getDayOfWeek(index: Int) -> String {
        let today = Date()
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .day, value: index, to: today) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
        return "Unknown Day"
    }
}

