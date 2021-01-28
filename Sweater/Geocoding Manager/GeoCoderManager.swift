//
//  GeoCoder.swift
//  Sweater
//
//  Created by Liana Haque on 1/27/21.
//

import Foundation
import CoreLocation
import PromiseKit

class GeoCoderManager {
    let geoCoder = CLGeocoder()

    //JLI: Move this to another class that does geocoding.  Make it more reusable.
    // Use this function to do the work of the function below.
    // This has human readable and the coordinate form of the location data.
    // Consider renaming this as well.
    func convertReadableLocationToCoordinates(searchBarEntry: String) -> Promise<CLLocation> {
        return Promise { seal in
            geoCoder.geocodeAddressString(searchBarEntry) { (placemarks, error) in
                guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    print("Could not retrieve coordinates.")
                    return
                }
                seal.fulfill(location)
            }
        }
    }
    
    func convertUserEntryToSearchableHumanReadableLocation(searchBarEntry: String) -> Promise<CLPlacemark> {
        return Promise { seal in
            geoCoder.geocodeAddressString(searchBarEntry) { (placemarks, error) in
                guard let placemarks = placemarks, let location = placemarks.first
                else {
                    print("Could not retrieve coordinates.")
                    return
                }
                seal.fulfill(location)
            }
        }
    }
    
//    func convertCoordinatesToReadableLocation() {
//       // let geoCoder = CLGeocoder()
//        let latitude = CLLocationDegrees(controller.latitude)
//        let longitude = CLLocationDegrees(controller.longitude)
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//
//        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
//             // Place details
//            guard let placeMark = placemarks?.first else { return }
//
//            // Location name
//            if let locationName = placeMark.location {
//                print(locationName)
//            }
//            // City
//            if var city = placeMark.subAdministrativeArea {
//                print(city)
//                self.readableLocation = city
//            }
//            // Zip code
//            if let zip = placeMark.isoCountryCode {
//                print(zip)
//            }
//            // Country
//            if let country = placeMark.country {
//                print(country)
//            }
//        }
//    }

}
