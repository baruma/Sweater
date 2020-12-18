//
//  WeatherController.swift
//  Sweater
//
//  Created by Liana Haque on 12/5/20.
//

import Foundation
import CoreLocation

class WeatherDisplayController {
    let repository = WeatherResponseRepository()
    
    func getMainTemperature(listener: FetchTemperatureListener) {
        // takes in the listener so it can give the data back to the view.  the controller doesn't need the result, so it can hand it right off to the view.  you would need to route the result back to the controller  if it was ever going to do something with it(i.e. save it, manipulate it, etc.).  Because we're just displaying it, we can just shoot the data back to the view, which is alright since it is under the guise of the listener.
        repository.fetchCurrentTemperature(latitude: 0.0, longitude: 0.0, listener: listener)
    }
    
}
// the protocol is the structure, shape or rules of the transaction to take place.  tech support can't just throw something outo f the garbage out at you, the need to give you actual procedures and follow a company protocol.
protocol FetchTemperatureListener {
    func onDataReceived(temp: Temperature)
}

protocol FetchWeatherDescriptionListener {
    func onDataReceived(weatherDescription: WeatherDescription)
}

//protocol FetchPromise<TYPE> {
//    
//    func onSuccess(result: TYPE)
//    func onFailure(error: Error)
//    
//}

/// make an object that conforms to this protocol.  make a new object in the middle of a function that extends a protocol.

/*
 We are using the protocol is a vehicle that moves between the view controller and data layers.  The protocol contains the promise of a response (but not necessarily the data itself).  The Temperature is the result in thise caes.  It doesn't necessarily contain the Result but just the shape.  Shape in thise context is the structure of how th listener is going to get the data.  it just sets up the rules of as to what the user will receive.
 
 The cell is saying I'll listen for the data.  Communicating to the controller as to whether or not it has received it.  Now we're in the controller layer.  When the controller gets the data (because the view asked the controller for data and now the controller is asking the repository for data).
 */
