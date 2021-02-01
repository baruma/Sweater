//
//  SweatCache.swift
//  Sweater
//
//  Created by Liana Haque on 1/6/21.
//

import Foundation

/// MARK: - CONSIDER MAKING THIS ASYNC LATER ON AS FRAMES WILL SKIP WITH THE MORE CALLS YOUR APPS MAKES

//JLI: Keep the latest OneCallResponse in memory (as a property) so we don't have to deserialize it every request
class SweatCache {
    private var lastUpdated: Date?
    private let freshThresholdInSeconds = 60*60 // 1 hour
    private var latitude: Float? = nil
    private var longitude: Float? = nil
    
    private var fileURL: URL {
      let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      return documents.appendingPathComponent("WeatherCache.txt")
    }
    
    func writeResponseToCache(response: String, latitude: Float, longitude: Float) {
        lastUpdated = Date()
        let responseInBytes: Data? = response.data(using: .utf8)
        self.latitude = latitude
        self.longitude = longitude 
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? responseInBytes!.write(to: fileURL)
        } else {
            FileManager.default.createFile(atPath: fileURL.path, contents: responseInBytes, attributes: nil)
        }
    }
    
    func readResponseFromCache() -> OneCallResponse {
        //JLI: Refactor so we don't have to have data! in line 36
        //  possibly update the respoinse to return OneCallResponse? and nil for some cases (like first time running after app install)
        let data = try? Data.init(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let oneCallResponse = try? decoder.decode(OneCallResponse.self, from: data!)
        return oneCallResponse!
    }

    func checkIsDataFresh(latitude: Float, longitude: Float) -> Bool {
        if self.latitude != latitude || self.longitude != longitude {
            return false
        }
        
        if (lastUpdated == nil) {
            return false
        }
        let currentDate = Date()
        let secondsDiff = currentDate.timeIntervalSince1970 - lastUpdated!.timeIntervalSince1970
        return Int(secondsDiff) < freshThresholdInSeconds
    }
}
