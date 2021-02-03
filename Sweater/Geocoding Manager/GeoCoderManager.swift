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
    
    func convertCoordinatesToHumanReadableLocation(location: CLLocation) -> Promise<CLPlacemark> {
        return Promise { seal in
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                guard let placemarks = placemarks, let location = placemarks.first
                else {
                    print("Could not retrieve human readable location from coordinates.")
                    return
                }
                seal.fulfill(location)
            }
        }
    }
}
