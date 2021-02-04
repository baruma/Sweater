//
//  WeatherResponseRepository.swift
//  Sweater
//
//  Created by Liana Haque on 12/5/20.
//

import Foundation
import Alamofire
import PromiseKit

//JLI: General notes: Refactor so we don't use
class WeatherResponseRepository {
    private let cache = SweatCache()
    private let mapper = WeatherMapper()
    private var fetchOneCallResponsePromise : Promise<OneCallResponse>? = nil
    
    func convertJSONToResponse(response: String) -> OneCallResponse {
        let responseInBytes: Data? = response.data(using: .utf8)
        let decoder = JSONDecoder()
        let oneCallResponse = try? decoder.decode(OneCallResponse.self, from: responseInBytes!)
        return oneCallResponse!
    }

    func fetchOneCallResponse(latitude: Float, longitude: Float) -> Promise<OneCallResponse> {
        guard let fetch = fetchOneCallResponsePromise else {
            fetchOneCallResponsePromise = createBaseFetchPromise(latitude: latitude, longitude: longitude)
            return fetchOneCallResponsePromise!
        }
        if (fetch.isResolved) {
            fetchOneCallResponsePromise = createBaseFetchPromise(latitude: latitude, longitude: longitude)
        }
        return fetchOneCallResponsePromise!
    }
    
    /**
     Error Handling in FetchOneCallResponse
     ======================================
     
     There are two flows that diverge from this function when it is error handling:
     
     1. If an error is received, the flow proceeds backwards to the Controller and then to the View in order to communicate to the user that a network issue has occured and their data cannot be received.
        
        1.1 Upon rejection, PromiseKit must use the Reject call and ensure that the final call in the chain is Catch as it handles the error last.
    
     2. The flow follows the success case and continues onward to the WeatherMapper to map the JSON data to Sweater's Data Models and then pass it back to the Controller, then to the View.
     */
    func createBaseFetchPromise(latitude: Float, longitude: Float) -> Promise<OneCallResponse> {
        if cache.checkIsDataFresh(latitude: latitude, longitude: longitude) == false {
            return Promise { seal in
                let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
                AF.request(endpoint).responseString { response in
                    switch response.result {
                    case .success:
                        self.cache.writeResponseToCache(response: response.value!, latitude: latitude, longitude: longitude)
                        let oneCallResponse = self.convertJSONToResponse(response: response.value!)
                        seal.fulfill(oneCallResponse)
                    case let .failure(error):
                        seal.reject(error)
                    }
                }
            }
        } else {
            return self.cache.readResponseFromCache()
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
       // var hourlyWeatherPayload = [HourlyWeather]()
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
// a better statement is that whatever datesource goes out of business you don't have to rewrite your view to get new data, you have this middle layer that represents your app's core model that a specific data source... i
