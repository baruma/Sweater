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
    func onResultSelected(selectedPlacemark: LocationSearchResult)
}
// when the cell needs something it talks to the controller and the controller pases it back

class WeatherDisplayPresenter: MVPPresenter<WeatherDisplayVC>, LocationResultListener {
    var locationSearchResult: LocationSearchResult? = nil
    
    func onResultSelected(selectedPlacemark: LocationSearchResult) {
        // You need to trigger the flow of fetching new data and updating the view.  You will do it from here.  You need to make a function on the VC side and do tableview.reloaddata() here.

        saveAndUpdateCoordinates(latitude: Float(selectedPlacemark.latitude), longitude: Float(selectedPlacemark.longitude))
        locationSearchResult = selectedPlacemark
        // This is where the usefulness of the attach feature comes from (Review that a second time).  You don't have to call the repository because the cells do this.
        self.view!.refreshViewWithNewSearchData()  // this recreates cells for new data
        
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
    
    // This is called by the VC which then gets the current locationSearchResult that the user got.  The VC is the listener, and it got the data, and the cell is meant to be dumb - all it does is configures the label with the data it gets.  So this func gets called by the VC.  
    func getCityName() -> LocationSearchResult? {
        return locationSearchResult
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
