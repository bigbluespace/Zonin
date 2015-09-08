//
//  ZoninAPIClient.h
//  Zonin
//
//  Created by Mamun on 9/20/14.
//  Copyright (c) 2014 ABCoder. All rights reserved.
//

#import "AFHTTPSessionManager.h"

//development
static NSString * const ZoninAPIBaseURLString = @"http://zoninapp.com/admin/backend/api_zonin/";





@interface ZoninAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;

@end
