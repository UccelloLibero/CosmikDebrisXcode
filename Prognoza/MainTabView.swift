//
//  MainTabView.swift
//  Prognoza
//
//  Created by Maya McPherson on 9/23/24.
//

import SwiftUI
import CoreLocation

struct MainTabView: View {
    @Binding var selectedTab: Int
    @State private var favoriteLocations: [String] = []
    @StateObject private var locationManager = LocationManager()
    @State private var locationName: String = "Your Location"  // Placeholder for the location name

    var body: some View {
        TabView(selection: $selectedTab) {
            if let userLocation = locationManager.userLocation {
                // Display the WeatherView with the current location's name and coordinates
                WeatherView(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude,
                    locationName: locationName  // Show actual location name
                )
                .tabItem {
                    Image(systemName: "sun.max")
                    Text("Weather")
                }
                .tag(0)
                .onAppear {
                    fetchLocationName(from: userLocation)
                }
            } else {
                // Placeholder view while location is loading
                Text("Loading location...")
                    .tabItem {
                        Image(systemName: "sun.max")
                        Text("Weather")
                    }
                    .tag(0)
            }

            SearchView(favoriteLocations: $favoriteLocations)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)

            FavoritesView(favoriteLocations: $favoriteLocations)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .tag(2)
        }
    }

    // Function to reverse geocode coordinates into a human-readable address
    func fetchLocationName(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                locationName = placemark.locality ?? "Unknown Location"
            } else {
                print("Error reverse geocoding location: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
