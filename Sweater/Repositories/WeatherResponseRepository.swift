//
//  WeatherResponseRepository.swift
//  Sweater
//
//  Created by Liana Haque on 12/5/20.
//

import Foundation
import Alamofire

class WeatherResponseRepository {
    let mapper = WeatherMapper()
    
    func fetchWeather(latitude: Float, longitude: Float) -> Void {
       // let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=&appid=\(Constants.APIKEY)")
        let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")

//        AF.request(endpoint).responseJSON { response in
//            print(response)
//
//        }
        AF.request(endpoint).responseDecodable(of: OneCallResponse.self) { response in
//            self.mapper.findMinimumTemperature(listOfHours: response.value!.hourly)
//            self.mapper.findMaximumTemperature(listOfHours: response.value!.hourly)
//            print(response.description)
//            print(response.value?.lat)
//            print(response.value?.timezone)
//            print(response.value?.current.weather)
//            print(response.value?.current.temp)
//            print(response.value?.current.feelsLike)
//            print(response.value?.hourly[0].weather)
                        
       }
}
    
    func fetchCurrentTemperature(latitude: Float, longitude: Float, listener: FetchTemperatureListener) {  // the repository doesn't know that the listener is a cell disguised as a cell.
        // Polymorphism is being used here above witht the listener being passed in.  In this case the listener from the View's perspective is that it's a cell and also a listener.
        let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
        AF.request(endpoint).responseDecodable(of: OneCallResponse.self) { response in
            let temp = self.mapper.mapToTemperatureModel(current: response.value!.current, hourly: response.value!.hourly)
            listener.onDataReceived(temp: temp)
        }
    }
    
//    func fetchWeatherDescriptions(latitude: Float, longitude: Float, listener: FetchWeatherDescriptionListener) {
//        let endpoint = ("https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude=&appid=\(Constants.APIKEY)")
//        AF.request(endpoint).responseDecodable { (response) in
//            let description = self.mapper.mapToWeatherDescriptionAggregate(current: <#T##Current#>)
//        }
//    }
}
// BASE URL : https://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
