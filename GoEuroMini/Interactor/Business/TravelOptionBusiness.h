//
//  TravelOptionBusiness.h
//  GoEuroMini
//
//  Created by Sasha on 26/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

#import <Foundation/Foundation.h>

//Success block for service call
typedef void (^TravelFetchSuccess) (NSArray *travelData);

//Failure block for service call
typedef void (^TravelFetchFailure) (NSError *error);

@interface TravelOptionBusiness : NSObject

//Use this to create the service request via the connection handler
- (void) callTravelApiForMode:(int)travelMode onSuccess:(TravelFetchSuccess)onSuccessBlock onFailure:(TravelFetchFailure)onFailureBlock;

@end
