//
//  OneCallResponse.swift
//  Sweater
//
//  Created by Liana Haque on 12/7/20.
//

import Foundation

/// This class is responsible for compiling the other data models into here and pull all their data at once.  This way you do not have to call each individual data model class from the Repository.

class OneCallResponse: Decodable {
    let lat: Float
    let lon: Float
    let timezone: String
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    let alerts: [Alert]?
}
