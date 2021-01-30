//
//  Hourly.swift
//  Sweater
//
//  Created by Liana Haque on 12/16/20.
//

import Foundation

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
