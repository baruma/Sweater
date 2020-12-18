//
//  Hourly.swift
//  Sweater
//
//  Created by Liana Haque on 12/16/20.
//

import Foundation

/// Sweater's MVP will only be using the temperature hourly data for its current needs.
/// This struct is populated with the rest of the corresponding hourly weather data in the event that any of it needs to be used for future versions.

struct HourlyWeather {
    let dt: Int
    let temp: Float
    let feelsLike: Float
    let pressure: Int
    let humidity: Int
    let visibility: Int
    let windSpeed: Double
    let weather: [Weather]
}
