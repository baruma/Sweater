//
//  Mapper.swift
//  Sweater
//
//  Created by Liana Haque on 12/8/20.
//

import Foundation
import UIKit

class WeatherMapper {
    
    func mapToTemperatureModel(current: Current, hourly: [Hourly]) -> Temperature {
        return Temperature(main: current.temp, feelsLike: current.feelsLike, min: findMinimumTemperature(listOfHours: hourly), max: findMaximumTemperature(listOfHours: hourly))
    }

//    func mapToWeatherDescriptionAggregate(current: Current) -> WeatherDescriptionAggregate {
//        let descriptions = current.weather.map{ WeatherDescription(general: $0.main, detailed: $0.description) }
//        return WeatherDescriptionAggregate(descriptions: descriptions)
//    }

    func mapToWeatherDescriptionAggregate(current: Current) -> WeatherDescriptionAggregate {
        var descriptions = [WeatherDescription]()
        for weather in current.weather {
            descriptions.append(WeatherDescription(general: weather.main, detailed: weather.description))
        }
        return WeatherDescriptionAggregate(descriptions: descriptions)
    }
    
    func mapToWeatherDetail(current: Current) -> WeatherDetail {
        return WeatherDetail(preessure: current.pressure, humidity: current.humidity, uvi: current.uvi, clouds: current.clouds, windSpeed: current.windSpeed)
    }
    
    func mapHourlyWeather(hourly: Hourly) -> HourlyWeather {
        return HourlyWeather(dt: hourly.dt, temp: hourly.temp, feelsLike: hourly.feelsLike, pressure: hourly.pressure, humidity: hourly.humidity, visibility: hourly.visibility, windSpeed: hourly.windSpeed, weather: hourly.weather)
    }
    
    
    /// The functions below find the min and max temperatures of the day. Should be placed in a different file away from the Mapper.
    
    func findMinimumTemperature(listOfHours: [Hourly]) -> Float {
        return listOfHours.prefix(12).map{$0.temp}.min()!
    }
    
    func findMaximumTemperature(listOfHours: [Hourly]) -> Float {
        return listOfHours.prefix(12).map{$0.temp}.max()!
    }
}
