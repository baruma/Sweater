//
//  Weather.swift
//  Sweater
//
//  Created by Liana Haque on 12/7/20.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}
