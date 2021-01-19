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

    /// We created the WeatherDescriptionAggregate because a day could have multiple weather descriptions (ex. snow + rain + fog)
    func mapToWeatherDescriptionAggregate(current: Current) -> WeatherDescriptionAggregate {
        var descriptions = [WeatherDescription]()
        for weather in current.weather {
            descriptions.append(WeatherDescription(main: weather.main, detailed: weather.description))
        }
        return WeatherDescriptionAggregate(descriptions: descriptions)
    }
    
    func mapToWeatherDetail(current: Current, hourly: Hourly) -> WeatherDetail {
        return WeatherDetail(pressure: current.pressure, humidity: current.humidity, precipitation: hourly.precipitation , uvi: current.uvi, clouds: current.clouds, windSpeed: current.windSpeed)
    }
    
    func mapToHourlyWeather(hourly: Hourly) -> HourlyWeather {
        return HourlyWeather(dt: hourly.dt, temp: hourly.temp, feelsLike: hourly.feelsLike, pressure: hourly.pressure, humidity: hourly.humidity, visibility: hourly.visibility, windSpeed: hourly.windSpeed, weather: hourly.weather)
    }
    
    func mapToWeeklyWeather(daily: Daily) -> WeeklyWeather {
        return WeeklyWeather(dt: daily.dt, temp: daily.temp, weather: daily.weather)
    }
    
    /// Below here, write out functions that map data to dusk + dawn

    func mapToDawnDusk(current: Current) -> DawnDusk {
        return DawnDusk(dawn: current.sunrise, dusk: current.sunset)
    }
    
    func mapToSupplementaryInformation(current: Current) -> SupplementaryInformation {
        return SupplementaryInformation(pressure: current.pressure, uvi: current.uvi, clouds: current.clouds, windSpeed: current.windSpeed)
    }
    
    /// The functions below find the min and max temperatures of the day. Should be placed in a different file away from the Mapper.
    
    func findMinimumTemperature(listOfHours: [Hourly]) -> Float {
        return listOfHours.prefix(12).map{$0.temp}.min()!
    }
    
    func findMaximumTemperature(listOfHours: [Hourly]) -> Float {
        return listOfHours.prefix(12).map{$0.temp}.max()!
    }
}
