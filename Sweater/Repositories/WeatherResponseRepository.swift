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
    
    // Using this to print location coordinates
//    func fetchWeather(latitude: Float, longitude: Float) -> Void {
//        let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
//
//        AF.request(endpoint).responseDecodable(of: OneCallResponse.self) { response in
//            print(response.value?.hourly[1].precipitation)
//            print(response.value!.current.weather[0])
//       }
//    }
    
    func fetchOneCallResponse(latitude: Float, longitude: Float) -> Promise<OneCallResponse> {
        return Promise { seal in
            let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
            if cache.checkIsDataFresh() == false {
                AF.request(endpoint).responseString { response in
                    self.cache.writeResponseToCache(response: response.value!)
                    let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                    seal.fulfill(oneCallResponse)
                }
            }
            else {
                let oneCallResponse = self.cache.readResponseFromCache()
                seal.fulfill(oneCallResponse)
            }
        }
    }
    func fetchWeatherData(latitude: Float, longitude: Float) -> Promise<Temperature> {
        return fetchOneCallResponse(latitude: latitude, longitude: longitude)
            .then { oneCallResponse -> Promise<Temperature> in
                let mappedResults = self.mapper.mapToTemperatureModel(current: oneCallResponse.current, hourly: oneCallResponse.hourly)
                return Promise.value(mappedResults)
            }
    }

    func fetchCurrentFeelsLike(latitude: Float, longitude: Float) -> Promise<Temperature> {
        #warning("that clusre syntax people keep talking about now you finally ran into it")
        return fetchOneCallResponse(latitude: latitude, longitude: longitude)
            .then { oneCallResponse -> Promise<Temperature> in
                let mappedResults = self.mapper.mapToTemperatureModel(current: oneCallResponse.current, hourly: oneCallResponse.hourly)
                return Promise.value(mappedResults)
            }
    }
    
    /// Should do something with renaiming detailWeatherListener since it doesn't apply to Feels Like Weather and creates some confusion.
    func fetchCurrentHumidity(latitude: Float, longitude: Float) -> Promise<WeatherDetail> {
        return fetchOneCallResponse(latitude: latitude, longitude: longitude)
            .then { oneCallResponse -> Promise <WeatherDetail>  in
                let mappedResults = self.mapper.mapToWeatherDetail(current: oneCallResponse.current, hourly: oneCallResponse.hourly.first!)
                return Promise.value(mappedResults)
            }
    }
    
    func fetchCurrentPrecipitation(latitude: Float, longitude: Float) -> Promise<WeatherDetail> {
        return fetchOneCallResponse(latitude: latitude, longitude: longitude)
            .then { oneCallResponse -> Promise <WeatherDetail>  in
                let mappedResults = self.mapper.mapToWeatherDetail(current: oneCallResponse.current, hourly: oneCallResponse.hourly.first!)
                return Promise.value(mappedResults)
            }
    }
    
    func fetchWeatherDescriptions(latitude: Float, longitude: Float) -> Promise<WeatherDescriptionAggregate> {
        return fetchOneCallResponse(latitude: latitude, longitude: longitude)
            .then { oneCallResponse -> Promise <WeatherDescriptionAggregate> in
                let mappedResults = self.mapper.mapToWeatherDescriptionAggregate(current: oneCallResponse.current)
                return Promise.value(mappedResults)
            }
    }
    
    func fetchHourlyWeather(latitude: Float, longitude: Float) -> Promise<[HourlyWeather]> {
        var hourlyWeatherPayload = [HourlyWeather]()
        return fetchOneCallResponse(latitude: latitude, longitude: longitude)
            .then { oneCallResponse -> Promise<[HourlyWeather]> in
                var hourlyWeatherPayload = [HourlyWeather]()
                for index in 0...oneCallResponse.hourly.count - 1 {
                    let mappedResult = self.mapper.mapToHourlyWeather(hourly: oneCallResponse.hourly[index])
                    hourlyWeatherPayload.append(mappedResult)
                }
                return Promise.value(hourlyWeatherPayload)
            }
    }

    func fetchWeeklyWeather(latitude: Float, longitude: Float) -> Promise<[WeeklyWeather]> {
        return fetchOneCallResponse(latitude: latitude, longitude: longitude)
            .then { oneCallResponse -> Promise<[WeeklyWeather]> in
                var weeklyWeatherPayload = [WeeklyWeather]()
                for index in 0...oneCallResponse.daily.count - 1 {
                    let mappedResult = self.mapper.mapToWeeklyWeather(daily: oneCallResponse.daily[index])
                    weeklyWeatherPayload.append(mappedResult)
                }
                return Promise.value(weeklyWeatherPayload)
            }
        
    }

    
    // Relevant af
//    func fetchCurrentPrecipitation(latitude: Float, longitude: Float) -> Promise<WeatherDetail> {
//        return fetchOneCallResponse(latitude: latitude, longitude: longitude)
//            .then { oneCallResponse -> Promise <WeatherDetail>  in
//                let mappedResults = self.mapper.mapToWeatherDetail(current: oneCallResponse.current, hourly: oneCallResponse.hourly.first!)
//                return Promise.value(mappedResults)
//            }
//    }
//
    
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
    
//    func baseFetch<DATA>(latitude: Float, longitude: Float) -> Promise<DATA> {
//        return Promise { seal in
//            let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
//            if cache.checkIsDataFresh() == false {
//                AF.request(endpoint).responseString { response in
//                    self.cache.writeResponseToCache(response: response.value!)
//                    let oneCallResponse = self.convertJSONToResponse(response: response.value!)
//                   //todo map to result
//                   // seal.fulfill()
//                }
//            }
//            else {
//                let oneCallResponse = self.cache.readResponseFromCache()
//               //todo map to result
//               // seal.fulfill()
//            }
//
//        }
//    }
    
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
    
    //        var weeklyWeatherPayload = [WeeklyWeather]()
    //        return Promise { seal in
    //            let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
    //            if cache.checkIsDataFresh() == false {
    //                AF.request(endpoint).responseString { response in
    //                    self.cache.writeResponseToCache(response: response.value!)
    //                    let oneCallResponse = self.convertJSONToResponse(response: response.value!)
    //                    for index in 0...oneCallResponse.daily.count - 1 {
    //                        let mappedResult = self.mapper.mapToWeeklyWeather(daily: oneCallResponse.daily[index])
    //                        weeklyWeatherPayload.append(mappedResult)
    //                    }
    //                    seal.fulfill(weeklyWeatherPayload)
    //                }
    //            }
    //            else {
    //                let oneCallResponse = self.cache.readResponseFromCache()
    //                for index in 0...oneCallResponse.daily.count - 1 {
    //                    let mappedResult = self.mapper.mapToWeeklyWeather(daily: oneCallResponse.daily[index])
    //                    weeklyWeatherPayload.append(mappedResult)
    //                }
    //                seal.fulfill(weeklyWeatherPayload)
    //            }
    //        }
    
    // WARNING: - THIS WILL ONLY EVER RETRIEVE THE FIRST INDEX OF THE ARRAY.  SEE IF YOU NEED TO MAKE 7 INDIVIDUAL REQUESTS OR HOW YOU CAN WORK THIS OUT.
    // response is the string we swapped it from decodable


}

/*
 when you want to refactor code you put the refactored code in a shared plce.  then take specific code that breaks the mold, and leave it alone.
 
 put shared code in one area and make room for unique code to run.
 */
