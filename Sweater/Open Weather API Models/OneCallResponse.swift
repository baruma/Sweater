//
//  OneCallResponse.swift
//  Sweater
//
//  Created by Liana Haque on 12/7/20.
//

import Foundation

/// Compiles all the other data models into here and pull all their data at once.  This way you do not have to call each individual data model class from the Repository. 

class OneCallResponse: Codable {
    let lat: Float
    let lon: Float
    let timezone: String
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    let alerts: [Alert]?
}
