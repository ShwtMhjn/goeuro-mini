//
//  TravelOptionEntityAndMarshalTest.swift
//  GoEuroMini
//
//  Created by Sasha on 27/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

import XCTest
@testable import GoEuroMini

class TravelOptionEntityAndMarshalTest: XCTestCase {
    var travelOption : TravelOption?
    var jsonDictionary : [[String : AnyObject]]?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        jsonDictionary = self.fetchJSONFromFile(name: "TravelOptionsMini")
        let travelOptions = TravelOptionMarshal.travelOptionsList(jsonArray: jsonDictionary)
        travelOption = travelOptions?.first
    }
    
    func fetchJSONFromFile(name: String) -> [[String : AnyObject]]?{
        if let path = Bundle.main.path(forResource: name, ofType: "txt") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    /*let jsonResult: [AnyObject]? = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                     if let _jsonResult = jsonResult {
                     jsonObject = _jsonResult
                     }*/
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: AnyObject]]
                    return jsonObject
                } catch {
                    return nil
                }
            } catch {
                return nil
            }
        }
        return nil
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSingleTravelOptionNotNil() {
        XCTAssertNotNil(travelOption, "TravelOption Nil!!!")
    }

    func testIdEquality() {
        XCTAssertEqual(travelOption?.itemId, 1, "Price string does not match")
    }

    func testPriceEquality() {
        XCTAssertEqual(travelOption?.priceInEuros, "€5.48", "Price string does not match")
    }

    func testDepartureTimeEquality() {
        XCTAssertEqual(travelOption?.departureTime, "2:41", "Departure string does not match")
    }

    func testArrivalTimeEquality() {
        XCTAssertEqual(travelOption?.arrivalTime, "16:56", "Arrival string does not match")
    }

    func testProviderLogoEquality() {
        XCTAssertEqual(travelOption?.providerLogoUrl, NSURL.init(string:"http://cdn-goeuro.com/static_content/web/logos/63/postbus.png"), "Provider logo url string does not match")
    }

    func testNumberOfStopsEquality() {
        XCTAssertEqual(travelOption?.numberOfStops, 2, "Number of Stops does not match")
    }

    func testDurationEquality() {
        XCTAssertEqual(travelOption?.duration, "14:15h", "Duration string does not match")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let jsonArray = self.fetchJSONFromFile(name: "TravelOptionsHuge")
            let _ = TravelOptionMarshal.travelOptionsList(jsonArray: jsonArray)
        }
    }
    
}
