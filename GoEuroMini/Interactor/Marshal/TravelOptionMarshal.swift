//
//  TravelOptionMarshal.swift
//  GoEuroMini
//
//  Created by Sasha on 25/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

import Foundation

class TravelOptionMarshal : NSObject {
    class func travelOption(jsonDictionary: [String: AnyObject]) -> TravelOption {
        let itemId = NSNumber.init(value:jsonDictionary.doubleForKey(Constants.kId))
        let providerLogo = NSURL.init(string: (jsonDictionary.stringForKey(Constants.kProviderLogo)).replacingOccurrences(of: "{size}", with: "63"))
        let priceInEuros = String(format: "€%.2f", jsonDictionary.doubleForKey(Constants.kPriceInEuros))
        let departureTime = jsonDictionary.stringForKey(Constants.kDepartureTime)
        let arrivalTime = jsonDictionary.stringForKey(Constants.kArrivalTime)
        let numberOfStops = NSNumber.init(value:jsonDictionary.doubleForKey(Constants.kNumberOfStops))
        let duration = departureTime.differenceFromDate(to:arrivalTime)
        let travelOption = TravelOption().travelOptionWithDictionary(itemId: itemId, providerLogoUrl: providerLogo!, priceInEuros: priceInEuros, departureTime: departureTime, arrivalTime: arrivalTime, duration: duration, numberOfStops: numberOfStops)
        return travelOption
    }
    
    class func travelOptionsList(jsonArray: [[String: AnyObject]]?) -> [TravelOption]? {
        var travelOptionsArray : [TravelOption]? = []
        if let _jsonArray = jsonArray {
            for travelOption in _jsonArray {
                travelOptionsArray?.append(self.travelOption(jsonDictionary: travelOption))
            }
        }
        return travelOptionsArray
    }
}

extension String{
    func convertToDate(format: String) -> Date? {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = format
        
        let date : Date? = formatter.date(from: self)
        return date
    }
    
    func differenceFromDate(to: String) -> String {
        let componentsFrom = self.components(separatedBy: ":")
        let componentsTo = to.components(separatedBy: ":")
        let minutesTo = Int(componentsTo.first!)! * 60 + Int(componentsTo.last!)!
        let minutesFrom = Int(componentsFrom.first!)! * 60 + Int(componentsFrom.last!)!
        let differenceInMinutes = minutesTo - minutesFrom
        let hours = differenceInMinutes / 60
        let minutes = differenceInMinutes % 60
        return "\(hours):\(minutes)h"
    }
}
