//
//  ErrorCodes.swift
//  Sweater
//
//  Created by Liana Haque on 12/14/20.
//

import Foundation

struct RuntimeError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
}
