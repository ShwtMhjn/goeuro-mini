//
//  WebConnectionHandler.h
//  WeatherOrNot
//
//  Created by Sasha on 06/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebConnectionHandler : NSObject

//Blocks for Success and Failure
typedef void (^OnSuccess) (NSURLResponse *response, NSData *data);
typedef void (^OnFailure) (NSURLResponse *response, NSData *data, NSError *error);

- (void)executeRequest:(NSURLRequest *)request onSuccess:(OnSuccess)onSuccessBlock
               failure:(OnFailure)onFailureBlock;

- (void)cancelCurrentService;

@end
