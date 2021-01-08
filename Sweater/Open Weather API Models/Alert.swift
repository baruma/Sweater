//
//  Alerts.swift
//  Sweater
//
//  Created by Liana Haque on 12/7/20.
//

import Foundation

struct Alert: Codable {
    let senderName: String
    let event: String
    let start: Int
    let end: Int
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event = "event"
        case start = "start"
        case end = "end"
        case description = "description"
    }
}
