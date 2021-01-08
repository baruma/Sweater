//
//  SweatCache.swift
//  Sweater
//
//  Created by Liana Haque on 1/6/21.
//

import Foundation

/// MARK - CONSIDER MAKING THIS ASYNC LATER ON AS FRAMES WILL SKIP WITH THE MORE CALLS YOUR APPS MAKES

class SweatCache {
    var lastUpdated: Date?
    let freshThresholdInSeconds = 60*60 // 1 hour
    
    private var fileURL: URL {
      let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      return documents.appendingPathComponent("WeatherCache.txt")
    }
    
    func writeResponseToCache(response: String) {
        lastUpdated = Date()
        let responseInBytes: Data? = response.data(using: .utf8)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? responseInBytes!.write(to: fileURL)
        } else {
            FileManager.default.createFile(atPath: fileURL.path, contents: responseInBytes, attributes: nil)
        }
    }
    
    func readResponseFromCache() -> OneCallResponse {
        let data = try? Data.init(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let oneCallResponse = try? decoder.decode(OneCallResponse.self, from: data!)
        return oneCallResponse!
    }

    func checkIsDataFresh() -> Bool {
        if (lastUpdated == nil) {
            return false
        }
        let currentDate = Date()
        let secondsDiff = currentDate.timeIntervalSince1970 - lastUpdated!.timeIntervalSince1970
        return Int(secondsDiff) < freshThresholdInSeconds
    }
}