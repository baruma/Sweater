//
//  WeatherResponseRepository.swift
//  Sweater
//
//  Created by Liana Haque on 12/5/20.
//

import Foundation
import Alamofire
import PromiseKit

//JLI: General notes: Refactor so we don't use !
class WeatherResponseRepository {
    
    //JLI: update visibility modifier
    let cache = SweatCache()
    let mapper = WeatherMapper()
    
    //JLI: You probably don't need convertJSONToResponse and fetchOneCallResponse
    func convertJSONToResponse(response: String) -> OneCallResponse {
        let responseInBytes: Data? = response.data(using: .utf8)
        let decoder = JSONDecoder()
        let oneCallResponse = try? decoder.decode(OneCallResponse.self, from: responseInBytes!)
        return oneCallResponse!
    }

    func fetchOneCallResponse(latitude: Float, longitude: Float) -> Promise<OneCallResponse> {
        return Promise { seal in
            let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
            if cache.checkIsDataFresh(latitude: latitude, longitude: longitude) == false {
                AF.request(endpoint).responseString { response in
                    self.cache.writeResponseToCache(response: response.value!, latitude: latitude, longitude: longitude)
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
        #warning("that closure syntax people keep talking about now you finally ran into it")
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
    
    func fetchDawnDusk(latitude: Float, longitude: Float) -> Promise<DawnDusk> {
        return fetchOneCallResponse(latitude: latitude, longitude: longitude)
            .then { oneCallResponse -> Promise<DawnDusk> in
                let mappedResult = self.mapper.mapToDawnDusk(current: oneCallResponse.current)
                return Promise.value(mappedResult)
            }
    }
    
    func fetchSupplementaryInformation(latitude: Float, longitude: Float) -> Promise<SupplementaryInformation> {
        return fetchOneCallResponse(latitude: latitude, longitude: longitude)
            .then { oneCallResponse -> Promise<SupplementaryInformation> in
                let mappedResult = self.mapper.mapToSupplementaryInformation(current: oneCallResponse.current)
                return Promise.value(mappedResult)
        }
    }
}
