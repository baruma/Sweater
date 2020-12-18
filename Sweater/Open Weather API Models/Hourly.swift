//
//  Hourly.swift
//  Sweater
//
//  Created by Liana Haque on 12/7/20.
//

import Foundation

struct Hourly: Decodable {
    let dt: Int
    let temp: Float
    let feelsLike: Float
    let pressure: Int
    let humidity: Int
    let visibility: Int
    let windSpeed: Double
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case temp = "temp"
        case feelsLike  = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
        case visibility = "visibility"
        case windSpeed = "wind_speed"
        case weather = "weather"
    }
}
