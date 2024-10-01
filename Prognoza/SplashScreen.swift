//
//  SplashScreen.swift
//  Prognoza
//
//  Created by Maya McPherson on 9/14/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false  // Controls when to switch to the main screen

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                Image("Cosmik Debris 2")  // Replace with your actual image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Text("Prognoza")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 20)
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
