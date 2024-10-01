//
//  SearchView.swift
//  Prognoza
//
//  Created by Maya McPherson on 9/23/24.
//

import SwiftUI
import CoreLocation

struct SearchView: View {
    @Binding var favoriteLocations: [String]  // Binding to favorite locations from MainTabView
    @State private var searchQuery: String = ""
    @State private var weatherData: WeatherData?
    @State private var showAlert: Bool = false  // For "Added to favorites" message
    @State private var locationFound = false

    var body: some View {
        ScrollView {  // Make the view scrollable
            VStack(alignment: .leading, spacing: 20) {
                // Header with title
                Text("Weather")
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading)

                // Search bar
                TextField("Enter location", text: $searchQuery)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)  // Make the text input full-width
                    .padding(.horizontal)

                // Search Button
                Button(action: {
                    searchForLocation()
                }) {
                    Text("Search")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#2A8FE6"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // Display weather information
                if let weatherData = weatherData {
                    VStack(alignment: .leading, spacing: 10) {
                        // Display location name and temperature
                        Text("Weather for \(searchQuery.capitalized)")
                            .font(.headline)

                        Text("\(Int(round(Double(weatherData.currentTemp) ?? 0)))°")
                            .font(.largeTitle)
                            .bold()

                        // Display weather icon and description
                        HStack {
                            Image(systemName: mapOpenWeatherIconToSystem(weatherData.forecastIcons.first ?? ""))
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(getIconColor(weatherData.forecastIcons.first ?? ""))
                            
                            Text(weatherData.description.capitalized)
                                .font(.title2)
                                .italic()
                        }

                        // Add to Favorites Button, hidden if location already added
                        if !favoriteLocations.contains(searchQuery) {
                            Button(action: {
                                addToFavorites()
                            }) {
                                Text("Add to Favorites")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "#9BC13B"))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }

                        // Show "Added to favorites" alert if added
                        if showAlert {
                            Text("Added to favorites")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#9BC13B"))
                                .transition(.opacity)
                                .padding(.top, 10)
                        }

                        // 5-day Forecast
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(0..<min(weatherData.forecastIcons.count, 5), id: \.self) { index in
                                HStack {
                                    // Day of the week
                                    Text(getDayOfWeek(index: index))
                                        .font(.headline)
                                        .foregroundColor(getTextColor())
                                        .frame(width: 100, alignment: .leading)

                                    // Weather icon
                                    Image(systemName: mapOpenWeatherIconToSystem(weatherData.forecastIcons[index]))
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(getIconColor(weatherData.forecastIcons[index]))
                                        .padding(.horizontal, 10)

                                    // Description of weather
                                    Text(weatherData.description.capitalized)
                                        .foregroundColor(getTextColor())
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    // Temperature
                                    Text("\(Int(round(Double(weatherData.currentTemp) ?? 0)))°")
                                        .bold()
                                        .foregroundColor(getTextColor())
                                        .frame(width: 50, alignment: .trailing)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 8)
                            }
                        }
                        .padding()
                    }
                    .padding()
                }

                Spacer()
            }
            .padding()
        }
    }

    // Search for location and fetch weather
    func searchForLocation() {
        CLGeocoder().geocodeAddressString(searchQuery) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                locationFound = true
                WeatherService.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { data in
                    self.weatherData = data
                }
            } else {
                locationFound = false
            }
        }
    }

    // Add searched location to favorites
    func addToFavorites() {
        if !favoriteLocations.contains(searchQuery) {
            favoriteLocations.append(searchQuery)
            showAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showAlert = false  // Fade out after 2 seconds
            }
        }
    }
    
    // Helper functions from WeatherView
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

    func getIconColor(_ icon: String) -> Color {
        switch icon {
        case "01d": return Color(hex: "#FEDA15") // Sun color
        case "09d", "09n", "10d", "10n": return Color(hex: "#1264ab") // Rain color
        case "02d", "02n", "03d", "03n", "04d", "04n": return Color(hex: "#B0B5CB") // Cloud color
        default: return .gray
        }
    }

    func getTextColor() -> Color {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 18 || hour < 6 ? Color(hex: "#FBFCFF") : Color(hex: "#212121")
    }
}
