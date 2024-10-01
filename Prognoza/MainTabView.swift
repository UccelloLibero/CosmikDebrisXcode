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

    var body: some View {
        TabView(selection: $selectedTab) {
            if let userLocation = locationManager.userLocation {
                // Pass the user's current location to WeatherView
                WeatherView(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude,
                    locationName: "Your Location"
                )
                .tabItem {
                    Image(systemName: "sun.max")
                    Text("Weather")
                }
                .tag(0)
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
}
