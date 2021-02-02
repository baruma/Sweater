//
//  SweatCache.swift
//  Sweater
//
//  Created by Liana Haque on 1/6/21.
//

import Foundation
import PromiseKit

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
    
    /*
     We don't use PromiseKit here since no data is being observed or passed around, it is just being written to the cache.  Write doesn't need promisekit
     This still takes 0.8 seconds on the main thread to do however, so this has to be asynchronous.
     */
    func writeResponseToCache(response: String, latitude: Float, longitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
        
        // You dont need main here since you are not doing anything UI related you're just writing to the function
        DispatchQueue.global().async {
            let responseInBytes: Data? = response.data(using: .utf8)
            if FileManager.default.fileExists(atPath: self.fileURL.path) {
                try? responseInBytes!.write(to: self.fileURL)
            } else {
                FileManager.default.createFile(atPath: self.fileURL.path, contents: responseInBytes, attributes: nil)
            }
        }
    }
    
    /*
     PromiseKit does play a hand here because we are retrieving data and need to ensure that we have something to give to the call.
     */
    func readResponseFromCache() -> Promise<OneCallResponse> {
        //JLI: Refactor so we don't have to have data! in line 36
        //  possibly update the respoinse to return OneCallResponse? and nil for some cases (like first time running after app install)
        
        
        // Just because code is in a Promise block doesn't mean it's asynchronous.  PromiseKit just does delivery and chaining , you still need dispatchqueue
        return Promise { seal in
            DispatchQueue.global().async {
                let data = try? Data.init(contentsOf: self.fileURL)
                let decoder = JSONDecoder()
                let oneCallResponse = try? decoder.decode(OneCallResponse.self, from: data!)
                
                DispatchQueue.main.async {
                    seal.fulfill(oneCallResponse!)
                }
            }
        }
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

// dispatchtime.now is a good way to find expensive functions and making them async from there.
//HW: Use dispatchtime.now to find what takes longer converting jsontobytes, reading and writing.
// Reading from file and decoding or writing to file and encoding
// and is decodingJSON and reading from the file (in bytes) more expensive
