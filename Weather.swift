//
//  Weather.swift
//  CosmikDebris
//
//  Created by Maya McPherson on 4/25/18.
//  Copyright © 2018 MAYA. All rights reserved.
//

import Foundation     // Required for UUID, URL, URLSession, JSONSerialization
import CoreLocation   // Required for CLLocationCoordinate2D

struct Weather: Identifiable {
    let id = UUID()
    let summary: String
    let iconURL: String
    let temperature: Double

    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }

    init(json: [String: Any]) throws {
        guard let weatherArray = json["weather"] as? [[String: Any]],
              let weather = weatherArray.first,
              let summary = weather["description"] as? String else {
            throw SerializationError.missing("summary is missing")
        }

        guard let iconCode = weather["icon"] as? String else {
            throw SerializationError.missing("icon is missing")
        }

        guard let main = json["main"] as? [String: Any],
              let temperature = main["temp"] as? Double else {
            throw SerializationError.missing("temperature is missing")
        }

        self.summary = summary
        self.iconURL = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        self.temperature = temperature
    }

    static let apiKey = "dcdefdfb65a5689109ba6c1212bce68d"
    static let basePath = "https://api.openweathermap.org/data/2.5/weather"

    static func forecast(withLocation location: CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        let url = basePath + "?lat=\(location.latitude)&lon=\(location.longitude)&units=imperial&appid=\(apiKey)"
        let request = URLRequest(url: URL(string: url)!)

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            var forecastArray: [Weather] = []

            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let weatherObject = try? Weather(json: json) {
                            forecastArray.append(weatherObject)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }

                completion(forecastArray)
            }
        }
        task.resume()
    }
}
