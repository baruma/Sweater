//
//  Temperature.swift
//  Sweater
//
//  Created by Liana Haque on 12/7/20.
//

import Foundation

/// Formerly Doubles instead of Floats

struct DailyTemperature: Decodable {
    let day: Float
    let night: Float
    let eve: Float
    let min: Float
    let max: Float
}
