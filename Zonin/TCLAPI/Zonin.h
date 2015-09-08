//
//  Zonin.h
//  Zonin
//
//  Created by Mamun on 9/20/14.
//  Copyright (c) 2014 ABCoder. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "ZoninAPIClient.h"


@interface Zonin : NSObject



// snapshot capture (convert view to image!)
+ (UIImage *) imageWithView:(UIView *)view;
// image file cache write
+(void)writeImage:(UIImage*)image fileName:(NSString*)fileName;

// image file cache read
+(UIImage*)readImage:(NSString*)fileName;

+(void)storeData:(NSDictionary*)json storageName:(NSString*)name;

+(NSMutableDictionary*)readData:(NSString*)name;

+ (NSURLSessionDataTask *)commonGet:(NSString*)url block:(void (^)(NSDictionary *JSON, NSError *error))block;
+ (NSURLSessionDataTask *)commonPost:(NSString*)url parameters:(NSDictionary*)parameters block:(void (^)(NSDictionary *JSON, NSError *error))block;
+ (NSURLSessionDataTask *)commonFileUpload:(NSString*)url data:(NSDictionary*)data
                 constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))formDataBlock
                                     block:(void (^)(NSDictionary *JSON, NSError *error))block;
+ (BOOL)isOnline;
@end
