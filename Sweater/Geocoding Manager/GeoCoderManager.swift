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

}
