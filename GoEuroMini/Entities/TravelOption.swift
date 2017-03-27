//
//  TravelOption.swift
//  GoEuroMini
//
//  Created by Sasha on 25/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

import Foundation

class TravelOption : NSObject {
    var itemId : NSNumber?
    var providerLogoUrl : NSURL?
    var priceInEuros : String?
    var departureTime : String?
    var arrivalTime : String?
    var duration : String?
    var numberOfStops : NSNumber?
    
    func travelOptionWithDictionary(itemId: NSNumber, providerLogoUrl: NSURL, priceInEuros: String, departureTime: String, arrivalTime: String, duration: String, numberOfStops: NSNumber) -> Self {
        self.itemId = itemId
        self.providerLogoUrl = providerLogoUrl
        self.priceInEuros = priceInEuros
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.duration = duration
        self.numberOfStops = numberOfStops
        return self
    }
}
