//
//  Current.swift
//  Sweater
//
//  Created by Liana Haque on 12/7/20.
//

import Foundation

/// Corresponds to Current in OpenWeatherMap
class BaseWeather: Decodable {
    /// dt means date and time received.
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let pressure: Int
    let humidity: Int
    let uvi: Float
    let clouds: Int
    let windSpeed: Double
    let weather : [Weather]
    
    init(dt: Int, sunrise: Int, sunset: Int, pressure: Int, humidity: Int, uvi: Float, clouds: Int, windSpeed: Double, weather: [Weather]) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.pressure = pressure
        self.humidity = humidity
        self.uvi = uvi
        self.clouds = clouds
        self.windSpeed = windSpeed
        self.weather = weather
    }

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case pressure = "pressure"
        case humidity = "humidity"
        case uvi = "uvi"
        case clouds = "clouds"
        case windSpeed = "wind_speed"
        case weather = "weather"
    }
}
