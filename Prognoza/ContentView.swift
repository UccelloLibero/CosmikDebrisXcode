//
//  ContentView.swift
//  Prognoza
//
//  Created by Maya McPherson on 9/12/24.
//  Copyright © 2018 MAYA. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WeatherView(latitude: 40.7128, longitude: -74.0060, locationName: "New York")  // Pass locationName
    }
}
