//
//  TravelOptionBusinessTest.m
//  GoEuroMini
//
//  Created by Sasha on 26/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebConnectionHandler.h"
#import "TravelOptionBusiness.h"
#import "Reachability.h"

static NSString *const kBaseURL = @"https://api.myjson.com/bins";
static NSString *const kFlightAPI = @"/w60i";
static NSString *const kTrainAPI = @"/3zmcy";
static NSString *const kBusAPI = @"/37yzm";

static NSString *const REQUEST_TYPE_GET = @"GET";
static NSString *const APPLICATION_CONTENT_TYPE_URLENCODED = @"application/x-www-form-urlencoded";
static NSString *const KEY_CONTENT_TYPE  = @"Content-Type";

@interface TravelOptionBusinessTest : XCTestCase
{
    WebConnectionHandler *webConnectionHandler;
    TravelOptionBusiness *travelOptionBusiness;
}

@end

@implementation TravelOptionBusinessTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    travelOptionBusiness = [[TravelOptionBusiness alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    travelOptionBusiness = nil;
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

//This one should pass even with no network because of cache
- (void)testTravelOptionsAPICall {
    [travelOptionBusiness callTravelApiForMode:0 onSuccess:^(NSArray *travelOptions) {
        XCTAssertNotNil(travelOptions, "Response is nil");
    } onFailure:^(NSError *error) {
        XCTAssert("Connection failed");
    }];
}

@end
