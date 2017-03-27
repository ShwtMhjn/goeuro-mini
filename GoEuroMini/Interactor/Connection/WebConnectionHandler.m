//
//  WebConnectionHandler.m
//  WeatherOrNot
//
//  Created by Sasha on 06/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

#import "WebConnectionHandler.h"
#import "Reachability.h"

#define STATUS_CODE_LOGIN_COOKIE       302

@interface WebConnectionHandler ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) OnSuccess successBlock;
@property (nonatomic, copy) OnFailure failureBlock;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@end

@implementation WebConnectionHandler

#pragma mark -- Execute Request --

- (void)executeRequest:(NSURLRequest *)request onSuccess:(OnSuccess)onSuccessBlock
               failure:(OnFailure)onFailureBlock{
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
    
    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 60.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    NSLog(@"Connecting URL -- %@",request.URL);
    NSLog(@"Request Body -- %@",[[NSString alloc]initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    self.successBlock = onSuccessBlock;
    self.failureBlock = onFailureBlock;
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setTimeoutInterval:30.0f];
    
    NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if(![WebConnectionHandler isNetworkReachable])
    {
        onSuccessBlock((NSURLResponse *)response, response.data);
    }
    else
    {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        
        __weak typeof(self)weakSelf = self;
        self.dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!error) {
                NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
                NSLog(@"Response code -- %ld",(long)resp.statusCode);
                NSLog(@"Response headers -- %@",resp.allHeaderFields);
                NSLog(@"Response -- %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                if (resp.statusCode < 400 && ((data.length >0) || (resp != nil)))
                {
                    onSuccessBlock (response , data);
                }
                else
                {
                    onFailureBlock(response,data,error);
                }
            }
            else
            {
                NSLog(@"Error - %@",error);
                
                if ([[error.localizedDescription lowercaseString] isEqualToString:[@"cancelled" lowercaseString]]) {
                    NSLog(@"Task Cancelled");
                }
                else{
                    onFailureBlock(response,data,error);
                }
            }
            if (strongSelf.dataTask.state != NSURLSessionTaskStateRunning) {
                [strongSelf.session invalidateAndCancel];
            }
        }];
    }
    [self.dataTask resume];
}

#pragma mark -- Cancel Service Request --

-(void)cancelCurrentService
{
    [self.dataTask cancel];
    self.dataTask = nil;
    self.session = nil;
}

- (void)URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error{
    [self cancelCurrentService];
}

#pragma mark - NSURLSession Delegates

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    
    if (([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) || ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodNTLM]))
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
    
    NSLog(@"NSURLSession Task did receive challenge. Unable to proceed.");
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)redirectResponse
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler{
    if (redirectResponse && [redirectResponse isKindOfClass:NSHTTPURLResponse.class])
    {
        NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)redirectResponse;
        NSInteger statusCode = [urlResponse statusCode];
        
        if (statusCode == STATUS_CODE_LOGIN_COOKIE)
        {
            self.successBlock(redirectResponse, nil);
            [self.session invalidateAndCancel];
            
            [task cancel]; // Terminate Connection
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    
}

#pragma mark -- Reachablity --
+ (BOOL) isNetworkReachable
{
    Reachability *reachbility = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachbility currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        return  NO;
    }
    
    return YES;
}


@end
