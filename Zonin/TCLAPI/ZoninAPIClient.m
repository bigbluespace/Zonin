//
//  ZoninAPIClient.m
//  Zonin
//
//  Created by Mamun on 9/20/14.
//  Copyright (c) 2014 ABCoder. All rights reserved.
//

#import "ZoninAPIClient.h"

@implementation ZoninAPIClient

+ (instancetype)sharedClient {
    static ZoninAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ZoninAPIClient alloc] initWithBaseURL:[NSURL URLWithString:ZoninAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        // ************ VERY VERY IMPORTANT for Zonin API *******************
        // it's using json as req body
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.requestSerializer.timeoutInterval = 1800;
        
    });
    return _sharedClient;
}
@end
