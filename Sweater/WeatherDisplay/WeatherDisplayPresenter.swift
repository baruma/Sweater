//
//  WeatherController.swift
//  Sweater
//
//  Created by Liana Haque on 12/5/20.
//

import Foundation
import CoreLocation
import PromiseKit

protocol LocationResultListener {
    // doesn't need a return type because it is delivering
    func onResultSelected(selectedPlacemark: LocationSearchResult)
}

class WeatherDisplayPresenter : MVPPresenter<WeatherDisplayVC>, LocationResultListener {
    func onResultSelected(selectedPlacemark: LocationSearchResult) {
        saveAndUpdateCoordinates(latitude: Float(selectedPlacemark.latitude), longitude: Float(selectedPlacemark.longitude))
        // You need to trigger the flow of fetching new data and updating the view.  You will do it from here.  You need to make a function on the VC side and do tableview.reloaddata() here.
        self.view!.refreshViewWithNewSearchData()  // This is where the usefulness of the attach feature comes from (Review that a second time).  You don't have to call the repository because the cells do this.
    }
    
    //JLI: add visibility modifier to these properties 
    private let repository = WeatherResponseRepository()
        
    // Coordinates for default location: New York City
    private var latitude: Float =  40.7128
    private var longitude: Float = -74.0060
    
    func saveAndUpdateCoordinates(latitude: Float, longitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
        print(latitude, longitude)
    }
    
    func getMainTemp() -> Promise<Temperature> {
        return repository.fetchWeatherData(latitude: latitude, longitude: longitude)
    }

    func getFeelsLikeTemperatureDetail() -> Promise<Temperature> {
       return repository.fetchCurrentFeelsLike(latitude: latitude, longitude: longitude)
    }

    func getHumidityDetail() -> Promise<WeatherDetail> {
       return repository.fetchCurrentHumidity(latitude: latitude, longitude: longitude)
    }
    
    func getPrecipitationDetail() -> Promise<WeatherDetail> {
        return repository.fetchCurrentPrecipitation(latitude: latitude, longitude: longitude)
    }
    
    func getWeatherDescription() -> Promise<WeatherDescriptionAggregate> {
        return repository.fetchWeatherDescriptions(latitude: latitude, longitude: longitude)
    }
    
    func getHourlyWeather() -> Promise<[HourlyWeather]> {
        return repository.fetchHourlyWeather(latitude: latitude, longitude: longitude)
    }
    
    func getWeeklyWeather() -> Promise<[WeeklyWeather]> {
       return repository.fetchWeeklyWeather(latitude: latitude, longitude: longitude)
    }
    
    func getDuskDawn() -> Promise<DawnDusk> {
        return repository.fetchDawnDusk(latitude: latitude, longitude: longitude)
    }
    
    func getSupplementaryInformation() -> Promise<SupplementaryInformation> {
        return repository.fetchSupplementaryInformation(latitude: latitude, longitude: longitude)
    }
}
