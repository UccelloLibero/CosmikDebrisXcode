//
//  PrognozaApp.swift
//  Prognoza
//
//  Created by Maya McPherson on 9/12/24.
//  Copyright © 2018 MAYA. All rights reserved.
//

import SwiftUI

@main
struct PrognozaApp: App {
    @State private var selectedTab: Int = 0  // To control the selected tab in MainTabView
    @State private var showMainView = false  // Control whether to show MainTabView after splash

    var body: some Scene {
        WindowGroup {
            if showMainView {
                MainTabView(selectedTab: $selectedTab)  // Pass the state binding
            } else {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showMainView = true
                        }
                    }
            }
        }
    }
}
