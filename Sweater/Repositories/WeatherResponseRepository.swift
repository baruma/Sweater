//
//  WeatherResponseRepository.swift
//  Sweater
//
//  Created by Liana Haque on 12/5/20.
//

import Foundation
import Alamofire

class WeatherResponseRepository {
    let cache = SweatCache()
    let mapper = WeatherMapper()
    
    func fetchWeather(latitude: Float, longitude: Float) -> Void {
        let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")

        AF.request(endpoint).responseDecodable(of: OneCallResponse.self) { response in
            print(response.value?.hourly[1].precipitation)
            print(response.value!.current.weather[0])
       }
    }
    
    func convertJSONToResponse(response: String) -> OneCallResponse {
        let responseInBytes: Data? = response.data(using: .utf8)
        let decoder = JSONDecoder()
        let oneCallResponse = try? decoder.decode(OneCallResponse.self, from: responseInBytes!)
        return oneCallResponse!
    }
    
    // the repository doesn't know that the listener is a cell disguised as a cell.
    // Polymorphism is being used here above witht the listener being passed in.  In this case the listener from the View's perspective is that it's a cell and also a listener.
    func fetchCurrentTemperature(latitude: Float, longitude: Float, listener: FetchTemperatureListener) {
        if cache.checkIsDataFresh() == false {
            let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
            AF.request(endpoint).responseString { response in
                self.cache.writeResponseToCache(response: response.value!)
                let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                let mappedResults = self.mapper.mapToTemperatureModel(current: oneCallResponse.current, hourly: oneCallResponse.hourly)
                listener.onDataReceived(temp: mappedResults)
                }
        } else {
            let oneCallResponse = self.cache.readResponseFromCache()
            let mappedResults = mapper.mapToTemperatureModel(current: oneCallResponse.current, hourly: oneCallResponse.hourly)
            listener.onDataReceived(temp: mappedResults)
        }
    }
    
    func fetchCurrentFeelsLike(latitude: Float, longitude: Float, listener: FetchWeatherDetailListener) {
        if cache.checkIsDataFresh() == false {
            let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
            AF.request(endpoint).responseString { response in
                self.cache.writeResponseToCache(response: response.value!)
                let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                listener.onDataReceived(weatherDetail: String(oneCallResponse.current.feelsLike))
            }
        }
        else {
           let oneCallResponse = self.cache.readResponseFromCache()
            listener.onDataReceived(weatherDetail: String(oneCallResponse.current.feelsLike))
       }
    }
    
    func fetchCurrentHumidity(latitude: Float, longitude: Float, listener: FetchWeatherDetailListener) {
        if cache.checkIsDataFresh() == false {
            let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
            AF.request(endpoint).responseString { response in
                self.cache.writeResponseToCache(response: response.value!)
                let oneCallResponse = self.convertJSONToResponse(response: response.value!)
               // let mappedResults = self.mapper.mapToWeatherDetail(current: oneCallResponse.current, hourly: oneCallResponse.hourly.first!)
                listener.onDataReceived(weatherDetail: String(oneCallResponse.current.humidity))
            }
        }
        else {
            let oneCallResponse = self.cache.readResponseFromCache()
            listener.onDataReceived(weatherDetail: String(oneCallResponse.current.humidity))
        }
    }
    
    func fetchCurrentPrecipitation(latitude: Float, longitude: Float, listener: FetchWeatherDetailListener) {
        let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
        AF.request(endpoint).responseDecodable(of: OneCallResponse.self) { response in
            let weatherDetail = self.mapper.mapToWeatherDetail(current: response.value!.current, hourly: response.value!.hourly[0])
            let precipitation = String(weatherDetail.precipitation)
            listener.onDataReceived(weatherDetail: precipitation)
        }
    }
    
    func fetchWeatherDescriptions(latitude: Float, longitude: Float, listener: FetchWeatherDescriptionListener) {
        let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
        AF.request(endpoint).responseDecodable(of: OneCallResponse.self) { response in
            let weatherDescriptionAggregate = self.mapper.mapToWeatherDescriptionAggregate(current: response.value!.current)
            listener.onDataReceived(weatherDescription: weatherDescriptionAggregate)
        }
    }
    // WARNING: - THIS WILL ONLY EVER RETRIEVE THE FIRST INDEX OF THE ARRAY.  SEE IF YOU NEED TO MAKE 7 INDIVIDUAL REQUESTS OR HOW YOU CAN WORK THIS OUT.
    func fetchHourlyWeather(latitude: Float, longitude: Float, listener: FetchHourlyWeatherListener) {
        let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
        AF.request(endpoint).responseDecodable(of: OneCallResponse.self) { response in
            var hourlyWeatherPayload = [HourlyWeather]()
            for index in 0...response.value!.hourly.count-1 {
                let hourlyWeather = self.mapper.mapToHourlyWeather(hourly: response.value!.hourly[index])
                hourlyWeatherPayload.append(hourlyWeather)
            }
            listener.onDataReceived(hourlyWeather: hourlyWeatherPayload)
        }
    }
    
    func fetchWeeklyWeather(latitude: Float, longitude: Float, listener: FetchWeeklyWeatherListener) {
        let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
        AF.request(endpoint).responseDecodable(of: OneCallResponse.self) { response in
            var weeklyWeatherPayload = [WeeklyWeather]()
            for index in 0...response.value!.daily.count-1 {
                let weeklyWeather = self.mapper.mapToWeeklyWeather(daily: response.value!.daily[index])
                weeklyWeatherPayload.append(weeklyWeather)
            }
            listener.onDataReceived(weeklyWeather: weeklyWeatherPayload)
        }
    }
}

// let mappedResults = self.mapper.mapToWeatherDetail(current: oneCallResponse.current, hourly: oneCallResponse.hourly.first!)
