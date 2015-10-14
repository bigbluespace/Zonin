//
//  Zonin.m
//  Zonin
//
//  Created by Mamun on 9/20/14.
//  Copyright (c) 2014 ABCoder. All rights reserved.
//

#import "Zonin.h"
//#import "LeftMenu.h"

@implementation Zonin

#pragma mark convert UIView to UIImage

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

#pragma mark - Utility methods - image cache read/write to local Document file

+(void)writeImage:(UIImage*)image fileName:(NSString*)fileName{
    NSString  *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", fileName]];
    // Write a UIImage to JPEG with minimum compression (best quality)
    // The value 'image' must be a UIImage object
    // The value '1.0' represents image compression quality as value from 0.0 to 1.0
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
}

+(UIImage*)readImage:(NSString*)fileName{
    NSString  *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", fileName]];
    return [UIImage imageWithContentsOfFile:filePath];
}

+(void)storeData:(NSDictionary*)json storageName:(NSString*)name {
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:data forKey:name];
    [defaults synchronize];
    
}
+(NSMutableDictionary*)readData:(NSString*)name{
    // NSDictionary* data;
    NSError* error;
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:name];
    if (data != nil) {
        NSDictionary* dic = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:kNilOptions
                             error:&error];
        
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        return mDic;
    }
    return nil;
}



#pragma mark - Error handling

+(NSString*)handleError:(NSError*)error {
    NSLog(@"e %@", error);
    NSString *errorMessage = [[NSString alloc] init];
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        //errorMessage = [[error.userInfo objectForKey:NSUnderlyingErrorKey] localizedDescription];
        errorMessage = @"No Internet Connection Available. Please Connect to Internet to use Zonin App.";
        //errorMessage = [error.userInfo valueForKey: NSLocalizedDescriptionKey];
    } else if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
        NSData *responseData = [error.userInfo valueForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSError* localError;
        NSDictionary *katchUpError = [[NSDictionary alloc] init];
        katchUpError = [NSJSONSerialization JSONObjectWithData:responseData
                                                       options:0
                                                         error:&localError];
        NSLog(@" ***** ZoninError **** %@", katchUpError);
        
        // weirdo!!!
        // from api the "listError" is just "EmailAlreadyExists", "errorMessage" contains the full textual description
        // but for other cases "listError" contains the full description
        // dirty trick! :( [get the longest string as error msg]
        errorMessage = [katchUpError valueForKeyPath:@"errorMessage"];
        NSString *listError = [[katchUpError valueForKeyPath:@"listError"] firstObject];
        
        
        if ([listError length] < [errorMessage length]) { // EmailAlreadyExists
            listError = errorMessage;
        }
        if (listError != nil) {
            errorMessage = listError;
        }
        
        // log out if token is expired
        if ([errorMessage isEqualToString:@"You need a valid token to access to a /auth/ path."]){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"auth"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    
    
    if (errorMessage == nil || errorMessage == (id)[NSNull null] || [errorMessage isEqualToString:@""]) {
        errorMessage =  @"Sorry, Zonin is currently unavailable, please try again later.";
    }
    
    
    NSLog(@" ERROR JSON %@", errorMessage);
    
    
    return errorMessage;
    
}

#pragma mark - Zonin API Methods



+ (NSURLSessionDataTask *)commonGet:(NSString*)url block:(void (^)(NSDictionary *JSON, NSError *error))block {
    
    NSLog(@"common URL %@", url);
    
    return [[ZoninAPIClient sharedClient]
            
            GET:url
            parameters:nil
            success:^(NSURLSessionDataTask * __unused task, id JSON) {
                NSLog(@"get data  %@", JSON);
                if (block) {
                    block(JSON, nil);
                }
            }
            failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                NSString *errorMsg = [self handleError:error];
                if (block && errorMsg != nil) {
                    block( @{ @"msg" : errorMsg } , error);
                } else {
                    block(nil , error);
                }            }];
}

+ (NSURLSessionDataTask *)commonPost:(NSString*)url parameters:(NSDictionary*)parameters block:(void (^)(NSDictionary *JSON, NSError *error))block {
    
    NSLog(@"path %@",url);
    NSLog(@"parameters %@",parameters);
    
    
    return [[ZoninAPIClient sharedClient]
            POST:url
            parameters:parameters
            success:^(NSURLSessionDataTask * __unused task, id JSON) {
                
                 NSDictionary*dataDic=[self parseJESONObjectFromData:JSON];
                
                
                
                NSLog(@"post return data  %@", dataDic);
                if (block) {
                    block(dataDic, nil);
                }
            }
            failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                NSString *errorMsg = [self handleError:error];
                if (block && errorMsg != nil) {
                    block( @{ @"msg" : errorMsg } , error);
                } else {
                    block(nil , error);
                }
            }];
}
+ (NSDictionary *)parseJESONObjectFromData:(NSData *)Data
{
    NSDictionary *parsedObject;
   // NSString* responseStr=[[NSString alloc]initWithData:Data encoding:NSUTF8StringEncoding];
    //NSLog(responseStr);
    
    @try
    {
        
        NSError *localError = nil;
        parsedObject = [NSJSONSerialization JSONObjectWithData:Data options:0 error:&localError];
        
        if (localError != nil) {
            NSLog(@"error occure:%@",localError);
        }
        else
        {
            NSLog(@"message %@",[parsedObject objectForKey:@"message"]);
            NSLog(@"status %@",[parsedObject objectForKey:@"status"]);
            NSLog(@"error: %@",[parsedObject objectForKey:@"error"]);
            // NSLog(@"mess %@ and count %d",[parsedObject objectForKey:@"message"],[parsedObject count]);
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception occured");
        //[self TostAlertMsg:@"An Error occure while connecting to server."];
        return nil;
    }
    @finally
    {
        
    }
    return  parsedObject;
    
}

+ (NSURLSessionDataTask *)commonFileUpload:(NSString*)url data:(NSDictionary*)data
                 constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))formDataBlock
                                     block:(void (^)(NSDictionary *JSON, NSError *error))block{
    
    
    NSLog(@"url %@", url);
    NSLog(@"postData %@", data);
    
    return [[ZoninAPIClient sharedClient]
            POST:url
            parameters:data
            constructingBodyWithBlock:formDataBlock
            success:^(NSURLSessionDataTask * __unused task, id JSON) {
                NSLog(@"successData  %@", JSON);
                
                NSDictionary*dataDic=[self parseJESONObjectFromData:JSON];
                 NSLog(@"successData  %@", dataDic);
                
                if (block) {
                    block(dataDic, nil);
                }
            }
            failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                NSString *errorMsg = [self handleError:error];
                if (block && errorMsg != nil) {
                    block( @{ @"msg" : errorMsg } , error);
                } else {
                    block(nil , error);
                }
            }];
}



+ (BOOL)isOnline{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
@end
