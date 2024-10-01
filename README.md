# Prognoza
Prognoza is a minimalist weather application built with Xcode and Swift, designed to intuitive experience for checking real-time weather updates and forecasts. The application fetches weather data from the OpenWeather API and displays it in a user-friendly interface.

## Features
- **Current Weather:** Get real-time weather updates for your current location using device GPS.
- **Daily Forecasts:** View 5-day weather forecasts with detailed temperature and weather conditions.
- **Search Functionality:** Search for weather information by city, town, or address using the search bar.
- **Add to Favorites:** Easily save favorite locations and access their weather details from the Favorites tab.
- **Minimalist Design:** Clean and functional user interface with intuitive navigation.
- **Dynamic Background and Icons:** Background color and icons change based on time of day and weather conditions.

## Usage
1. Launch the application.
2. By default, the weather information for your **current location** will be displayed.
3. Use the search bar to enter the name of a city, town, or address to get the weather forecast for that location.
4. View current weather and 5-day forecasts.
5. Add locations to your **Favorites** for quick access to their weather information.


## Code Overview

### `WeatherData.swift`
This file defines the data models for both current weather and forecasted weather data. It also handles JSON parsing to ensure the app accurately reflects the API response.

### `WeatherService.swift`
The WeatherService is responsible for making API requests and parsing the weather data from the OpenWeather API. This includes both current weather data and 5-day forecasts based on location coordinates (latitude and longitude).

### `MainTabView.swift`
This file manages the main navigation of the app, which is structured into three tabs: Weather, Search, and Favorites. The current weather for your location is displayed in the Weather tab, while search and saved locations are available through the other tabs.

### `SearchView.swift`
Handles location-based weather searches. Users can enter a city, town, or address and get real-time weather data along with a 5-day forecast. A button is provided to add the searched location to the Favorites list.

### `FavoritesView.swift`
Displays weather information for the user's saved favorite locations. Favorites can be added from the SearchView and managed (added or removed) directly in this view.

### `AppDelegate.swift`
Manages the application lifecycle events and sets up initial configurations.

## Design & UX
The user interface is built with simplicity and minimalism in mind. The color scheme dynamically adapts to time of day, with subtle changes in background and text colors based on morning, afternoon, and night. Weather icons provide a quick visual cue to the conditions, and the overall layout is designed for easy navigation, whether you're searching for weather, viewing forecasts, or managing favorites.

## Contact
Created by [Maya](maya@mcpherson.io).
