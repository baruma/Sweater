//
//  CityAndCountry.swift
//  Sweater
//
//  Created by Liana Haque on 1/27/21.
//

import Foundation
import CoreLocation

struct LocationSearchResult {
    let city: String
    let administrativeArea: String
    let country: String
    let latitude: Double
    let longitude: Double
}

extension LocationSearchResult {
   static func convertPlacemarkToLocationSearchResult(placemark: CLPlacemark) -> LocationSearchResult {

        let cityName = placemark.locality ?? ""
        let administrativeAreaName = placemark.administrativeArea ?? ""
        let countryName = placemark.country ?? ""
        let latitude = placemark.location?.coordinate.latitude ?? 0.0
        let longitude = placemark.location?.coordinate.longitude ?? 0.0
        
        return LocationSearchResult(city: cityName, administrativeArea: administrativeAreaName, country: countryName, latitude: latitude, longitude: longitude)
    }
}
