//
//  UWebOparetion.h
//  symptom-monitor
//
//  Created by Arifuzzaman likhon on 8/7/14.
//  Copyright (c) 2014 ubitrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

//@class Reachability;
@interface UWebOparetion : NSObject
-(NSData*)sendDataByPostWithFieldName:(NSArray*) FieldName andValue:(NSMutableArray*)Value forWebPage:(NSString*)webpage;
-(NSData*)sendDataByPostWithFieldNameAndFile:(NSArray *)FieldName andValue:(NSMutableArray *)Value forWebPage:(NSString *)webpage andFile:(NSString*)Filename;
-(NSData*)sendRequestForPostUrl:(NSString*) stringData webpage:(NSString*)webpage;
-(NSDictionary*)parseJESONObjectFromData:(NSData*)Data;
-(BOOL)isConnected;
@end
