//
//  Current.swift
//  Sweater
//
//  Created by Liana Haque on 12/7/20.
//

//import Foundation

/// This class is responsible for initializing the BaseWeather data model.
class Current: BaseWeather {
    var temp: Float
    var feelsLike: Float
    
    init(dt: Int, sunrise: Int, sunset: Int, temp: Float, feelsLike: Float, pressure: Int, humidity: Int, uvi: Float, clouds: Int, visibility: Int, windSpeed: Double, weather: [Weather]) {
        self.temp = temp
        self.feelsLike = feelsLike
        super.init(dt: dt, sunrise: sunrise, sunset: sunset, pressure: pressure, humidity: humidity, uvi: uvi, clouds: clouds, windSpeed: windSpeed, weather: weather)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Float.self, forKey: .temp)
        self.feelsLike = try container.decode(Float.self, forKey: .feelsLike)
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
    }
}
