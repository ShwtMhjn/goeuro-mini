//
//  TravelOptionBusiness.m
//  GoEuroMini
//
//  Created by Sasha on 26/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

#import "TravelOptionBusiness.h"
#import "WebConnectionHandler.h"
#import "GoEuroMini-Swift.h"

@implementation TravelOptionBusiness

#pragma mark -- Call Service --

- (void) callTravelApiForMode:(int)travelMode onSuccess:(TravelFetchSuccess)onSuccessBlock onFailure:(TravelFetchFailure)onFailureBlock
{
    TravelMode _travelMode = (TravelMode)travelMode;
    __block NSError *error = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[Constants kBaseURL], [self getURLForTravelMode:_travelMode]];
    
    NSURLRequest *request = [self createRequestWithURL:urlString withBody:nil andHeader:[[NSDictionary alloc]initWithObjectsAndKeys:[Constants APPLICATION_CONTENT_TYPE_URLENCODED],[Constants KEY_CONTENT_TYPE], nil] method:[Constants REQUEST_TYPE_GET]];
    
    WebConnectionHandler *webConnectionHandler = [[WebConnectionHandler alloc] init];
    [webConnectionHandler executeRequest:request onSuccess:^(NSURLResponse *response, NSData *data) {
        NSArray *responseArray = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        NSArray *travelOptionsArray = [TravelOptionMarshal travelOptionsListWithJsonArray:responseArray];
        if (travelOptionsArray.count > 0)
        {
            onSuccessBlock(travelOptionsArray);
        }
        else
        {
            onFailureBlock(error);
        }
        
    } failure:^(NSURLResponse *response, NSData *data, NSError *error) {
        onFailureBlock(error);
    }];
}

#pragma mark -- Get Request URL--
- (NSString *) getURLForTravelMode: (TravelMode)travelMode
{
    switch (travelMode) {
        case TravelModeFLIGHT:
            return [Constants kFlightAPI];
            break;
        case TravelModeBUS:
            return [Constants kBusAPI];
            break;
        case TravelModeTRAIN:
            return [Constants kTrainAPI];
            break;
        default:
            return @"";
            break;
    }
}

#pragma mark -- Create Request --
- (NSMutableURLRequest *) createRequestWithURL:(NSString *) url withBody:(NSString *) body andHeader:(NSDictionary *) header method:(NSString*)requestMethod {
    NSString *urlString = url;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:[Constants CONNECTION_TIME_OUT]];
    
    [request setHTTPMethod:requestMethod];
    
    if ([requestMethod isEqualToString:[Constants REQUEST_TYPE_POST]]) {
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [request setAllHTTPHeaderFields:header];
    return request;
}

@end
