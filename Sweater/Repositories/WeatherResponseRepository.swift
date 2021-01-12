//
//  WeatherResponseRepository.swift
//  Sweater
//
//  Created by Liana Haque on 12/5/20.
//

import Foundation
import Alamofire
import PromiseKit

class WeatherResponseRepository {
    let cache = SweatCache()
    let mapper = WeatherMapper()
    
    func convertJSONToResponse(response: String) -> OneCallResponse {
        let responseInBytes: Data? = response.data(using: .utf8)
        let decoder = JSONDecoder()
        let oneCallResponse = try? decoder.decode(OneCallResponse.self, from: responseInBytes!)
        return oneCallResponse!
    }
    
    func fetchWeather(latitude: Float, longitude: Float) -> Void {
        let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")

        AF.request(endpoint).responseDecodable(of: OneCallResponse.self) { response in
            print(response.value?.hourly[1].precipitation)
            print(response.value!.current.weather[0])
       }
    }

    // the repository doesn't know that the listener is a cell disguised as a cell.
    // Polymorphism is being used here above witht the listener being passed in.  In this case the listener from the View's perspective is that it's a cell and also a listener.
    
//    func fetchCurrentTemperature(latitude: Float, longitude: Float, listener: FetchTemperatureListener) {
//        if cache.checkIsDataFresh() == false {
//            let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
//            AF.request(endpoint).responseString { response in
//                self.cache.writeResponseToCache(response: response.value!)
//                let oneCallResponse = self.convertJSONToResponse(response: response.value!)
//                let mappedResults = self.mapper.mapToTemperatureModel(current: oneCallResponse.current, hourly: oneCallResponse.hourly)
//                listener.onDataReceived(temp: mappedResults)
//                }
//        } else {
//            let oneCallResponse = self.cache.readResponseFromCache()
//            let mappedResults = mapper.mapToTemperatureModel(current: oneCallResponse.current, hourly: oneCallResponse.hourly)
//            listener.onDataReceived(temp: mappedResults)
//        }
//    }
    
    func fetchWeatherData(latitude: Float, longitude: Float) -> Promise<Temperature> {
        return Promise { seal in
            if cache.checkIsDataFresh() == false {
                let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
                AF.request(endpoint).responseString { response in
                    self.cache.writeResponseToCache(response: response.value!)
                    let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                    let mappedResults = self.mapper.mapToTemperatureModel(current: oneCallResponse.current, hourly: oneCallResponse.hourly)
                    seal.fulfill(mappedResults)
                    }
            } else {
                let oneCallResponse = self.cache.readResponseFromCache()
                let mappedResults = mapper.mapToTemperatureModel(current: oneCallResponse.current, hourly: oneCallResponse.hourly)
                seal.fulfill(mappedResults)
            }
        }
    }

    func fetchCurrentFeelsLike(latitude: Float, longitude: Float) -> Promise<Temperature> {
        return Promise { seal in
            if cache.checkIsDataFresh() == false {
                let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
                AF.request(endpoint).responseString { response in
                    self.cache.writeResponseToCache(response: response.value!)
                    let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                    let mappedResults = self.mapper.mapToTemperatureModel(current: oneCallResponse.current, hourly: oneCallResponse.hourly)
                    seal.fulfill(mappedResults)
                    //listener.onDataReceived(weatherDetail: String(oneCallResponse.current.feelsLike))  // this method just wants a string so we dont' need the mapped result
                }
            }
            else {
               let oneCallResponse = self.cache.readResponseFromCache()
               let mappedResults = mapper.mapToTemperatureModel(current: oneCallResponse.current, hourly: oneCallResponse.hourly)
               seal.fulfill(mappedResults)
           }
        }
    }
    
    /// Should do something with renaiming detailWeatherListener since it doesn't apply to Feels Like Weather and creates some confusion.
    func fetchCurrentHumidity(latitude: Float, longitude: Float) -> Promise<WeatherDetail> {
        return Promise { seal in
            if cache.checkIsDataFresh() == false {
                let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
                AF.request(endpoint).responseString { response in
                    self.cache.writeResponseToCache(response: response.value!)
                    let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                    let mappedResults = self.mapper.mapToWeatherDetail(current: oneCallResponse.current, hourly: oneCallResponse.hourly.first!)
                    //listener.onDataReceived(weatherDetail: String(oneCallResponse.current.humidity))
                    seal.fulfill(mappedResults)
                }
            }
            else {
                let oneCallResponse = self.cache.readResponseFromCache()
                let mappedResults = mapper.mapToWeatherDetail(current: oneCallResponse.current, hourly: oneCallResponse.hourly.first!)
                seal.fulfill(mappedResults)
            }
        }
    }
    
    func fetchCurrentPrecipitation(latitude: Float, longitude: Float) -> Promise<WeatherDetail> {
        return Promise { seal in
            if cache.checkIsDataFresh() == false {
                let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
                AF.request(endpoint).responseString { response in
                    self.cache.writeResponseToCache(response: response.value!)
                    let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                    let mappedResults = self.mapper.mapToWeatherDetail(current: oneCallResponse.current, hourly: oneCallResponse.hourly.first!)
                    seal.fulfill(mappedResults)
                }
            }
            else {
                let oneCallResponse = self.cache.readResponseFromCache()
                let mappedResults = mapper.mapToWeatherDetail(current: oneCallResponse.current, hourly: oneCallResponse.hourly.first!)
                seal.fulfill(mappedResults)
            }
        }
    }
    
    func fetchWeatherDescriptions(latitude: Float, longitude: Float) -> Promise<WeatherDescriptionAggregate> {
        return Promise { seal in
            if cache.checkIsDataFresh() == false {
                let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
                AF.request(endpoint).responseString { response in
                    self.cache.writeResponseToCache(response: response.value!)
                    let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                    let mappedResults = self.mapper.mapToWeatherDescriptionAggregate(current: oneCallResponse.current)
                    seal.fulfill(mappedResults)
                }
            }
            else {
                let oneCallResponse = self.cache.readResponseFromCache()
                let mappedResults = mapper.mapToWeatherDescriptionAggregate(current: oneCallResponse.current)
                seal.fulfill(mappedResults)
            }
        }
    }
    
    func fetchHourlyWeather(latitude: Float, longitude: Float) -> Promise<[HourlyWeather]> {
        var hourlyWeatherPayload = [HourlyWeather]()
        return Promise { seal in
            if cache.checkIsDataFresh() == false {
                let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
                AF.request(endpoint).responseString { response  in
                    self.cache.writeResponseToCache(response: response.value!)
                    let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                    for index in 0...oneCallResponse.hourly.count-1 {
                        let mappedResult = self.mapper.mapToHourlyWeather(hourly: oneCallResponse.hourly[index])
                        hourlyWeatherPayload.append(mappedResult)
                    }
                    seal.fulfill(hourlyWeatherPayload)
                }
            }
            else {
                let oneCallResponse = self.cache.readResponseFromCache()
                for index in 0...oneCallResponse.hourly.count - 1 {
                    let mappedResult = self.mapper.mapToHourlyWeather(hourly: oneCallResponse.hourly[index])
                    hourlyWeatherPayload.append(mappedResult)
                }
                seal.fulfill(hourlyWeatherPayload)
            }
        }
    }

    func fetchWeeklyWeather(latitude: Float, longitude: Float) -> Promise<[WeeklyWeather]> {
        var weeklyWeatherPayload = [WeeklyWeather]()
        return Promise { seal in
            let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
            if cache.checkIsDataFresh() == false {
                AF.request(endpoint).responseString { response in
                    self.cache.writeResponseToCache(response: response.value!)
                    let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                    for index in 0...oneCallResponse.daily.count - 1 {
                        let mappedResult = self.mapper.mapToWeeklyWeather(daily: oneCallResponse.daily[index])
                        weeklyWeatherPayload.append(mappedResult)
                    }
                    seal.fulfill(weeklyWeatherPayload)
                }
            }
            else {
                let oneCallResponse = self.cache.readResponseFromCache()
                for index in 0...oneCallResponse.daily.count - 1 {
                    let mappedResult = self.mapper.mapToWeeklyWeather(daily: oneCallResponse.daily[index])
                    weeklyWeatherPayload.append(mappedResult)
                }
                seal.fulfill(weeklyWeatherPayload)
            }
        }
    }
    
//    func fetchCurrentFeelsLike(latitude: Float, longitude: Float, listener: FetchWeaherDetailListener) {
//        if cache.checkIsDataFresh() == false {
//            let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
//            AF.request(endpoint).responseString { response in
//                self.cache.writeResponseToCache(response: response.value!)
//                let oneCallResponse = self.convertJSONToResponse(response: response.value!)
//                listener.onDataReceived(weatherDetail: String(oneCallResponse.current.feelsLike))  // this method just wants a string so we dont' need the mapped result
//            }
//        }
//        else {
//           let oneCallResponse = self.cache.readResponseFromCache()
//            listener.onDataReceived(weatherDetail: String(oneCallResponse.current.feelsLike))
//       }
//    }
    
    // WARNING: - THIS WILL ONLY EVER RETRIEVE THE FIRST INDEX OF THE ARRAY.  SEE IF YOU NEED TO MAKE 7 INDIVIDUAL REQUESTS OR HOW YOU CAN WORK THIS OUT.
    // response is the string we swapped it from decodable


}
