//
//  Daily.swift
//  Sweater
//
//  Created by Liana Haque on 12/7/20.
//

import Foundation

class Daily: BaseWeather {
    var temp: DailyTemperature

    init(dt: Int, sunrise: Int, sunset: Int, temp: DailyTemperature, pressure: Int, humidity: Int, uvi: Float, clouds: Int, visibility: Int, windSpeed: Double, weather: [Weather]) {
        self.temp = temp
        super.init(dt: dt, sunrise: sunrise, sunset: sunset, pressure: pressure, humidity: humidity, uvi: uvi, clouds: clouds, windSpeed: windSpeed, weather: weather)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(DailyTemperature.self, forKey: .temp)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
    }
}
