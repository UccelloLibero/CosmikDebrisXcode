//
//  FavoritesView.swift
//  Prognoza
//
//  Created by Maya McPherson on 9/23/24.
//

import SwiftUI
import CoreLocation

struct FavoritesView: View {
    @Binding var favoriteLocations: [String]  // Bind to SearchView's favoriteLocations array
    @State private var weatherDataForFavorites: [String: WeatherData] = [:]  // Store weather data for each location
    @State private var isEditing = false  // Toggle for edit mode
    @State private var showAlert = false
    @State private var locationToRemove: String?

    var body: some View {
        VStack {
            // Header with title and options menu
            HStack {
                Text("Favorite Locations")
                    .font(.headline)
                    .padding(.leading)

                Spacer()

                Menu {
                    Button(action: {
                        isEditing.toggle()  // Toggle edit mode
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                    }

                    Button(action: {
                        // Add toggle between Fahrenheit and Celsius
                    }) {
                        Text("Toggle Fahrenheit/Celsius")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title)
                        .padding()
                }
            }
            .padding(.top)

            // List to display favorite locations and their weather
            List {
                ForEach(favoriteLocations, id: \.self) { location in
                    VStack(alignment: .leading) {
                        // First row: Location name and current temperature
                        HStack {
                            Text(location)
                                .font(.headline)
                            Spacer()
                            if let weather = weatherDataForFavorites[location] {
                                Text("\(weather.currentTemp)°")
                            } else {
                                Text("Loading...")
                            }
                        }

                        // Second row: Weather description
                        HStack {
                            if let weather = weatherDataForFavorites[location] {
                                Text(weather.description)
                            } else {
                                Text("Weather data unavailable")
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .overlay(
                        HStack {
                            Spacer()
                            // Show delete button in edit mode
                            if isEditing {
                                Button(action: {
                                    locationToRemove = location
                                    showAlert = true
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .padding(.trailing)
                            }
                        }
                    )
                    .onAppear {
                        fetchWeatherData(for: location)
                    }
                }
                .onDelete(perform: removeFavorite)
            }
            .listStyle(PlainListStyle())

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Remove Favorite?"),
                message: Text("Are you sure you want to remove \(locationToRemove ?? "") from favorites?"),
                primaryButton: .destructive(Text("Yes")) {
                    if let location = locationToRemove {
                        removeFavorite(at: IndexSet(integer: favoriteLocations.firstIndex(of: location)!))
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("Favorites")
    }

    // Fetch real weather data for the specified location
    func fetchWeatherData(for location: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { placemarks, error in
            if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate {
                // Use the WeatherService to fetch the real weather data from the API
                WeatherService.fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { weatherData in
                    if let data = weatherData {
                        DispatchQueue.main.async {
                            weatherDataForFavorites[location] = data
                        }
                    } else {
                        print("Failed to fetch weather data for location: \(location)")
                    }
                }
            } else {
                print("Failed to geocode location: \(location)")
            }
        }
    }

    // Remove a location from favorites using an IndexSet
    func removeFavorite(at offsets: IndexSet) {
        offsets.forEach { index in
            let location = favoriteLocations[index]
            favoriteLocations.remove(at: index)
            weatherDataForFavorites[location] = nil
        }
    }
}
