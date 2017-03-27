//
//  Constants.swift
//  MovieWebService
//
//  Created by Sasha on 07/03/17.
//

import Foundation

//MARK: -- Enum -- Travel Mode --
@objc public enum TravelMode : Int {
    case FLIGHT,
    TRAIN,
    BUS
}

//MARK: -- Enum -- Sort Mode --
@objc public enum SortBy : Int {
    case PRICE,
    DURATION,
    DEPARTURE
}

@objc public class Constants : NSObject {
    
    //MARK: -- URLs
    static let kBaseURL : String = "https://api.myjson.com/bins"
    static let kFlightAPI : String  = "/w60i"
    static let kTrainAPI : String = "/3zmcy"
    static let kBusAPI : String = "/37yzm"
    
    static let REQUEST_TYPE_POST = "POST"
    static let REQUEST_TYPE_GET = "GET"
    static let CONNECTION_TIME_OUT = 30
    static let APPLICATION_CONTENT_TYPE_URLENCODED = "application/x-www-form-urlencoded"
    static let KEY_CONTENT_TYPE  = "Content-Type"

    static let kNetworkErrorDomain : String  = "Network Unreachable"
    static let kNetworkErrorCode : Int = 999

    //MARK: -- Parsing Keys -- COMMON --
    static let kEmptyString : String = "";
    static let kZeroInteger : Int   = 0
    static let kZeroDouble  : Double = 0

    static let kGenericDate : Date = Date.distantPast;
    
    //MARK: -- Parsing Keys -- TRAVEL OPTION --
    static let kId : String = "id"
    static let kProviderLogo : String = "provider_logo"
    static let kPriceInEuros : String = "price_in_euros"
    static let kDepartureTime : String = "departure_time"
    static let kArrivalTime : String = "arrival_time"
    static let kNumberOfStops : String = "number_of_stops"

    //MARK: -- Formatters --
    static let kTimeFormat : String = "HH:mm"
}
