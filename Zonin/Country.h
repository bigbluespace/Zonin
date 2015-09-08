//
//  Country.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/17/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App-Utilities.h"
#import "UWebOparetion.h"

@interface Country : NSObject
@property NSString *Name;
@property int country_id;
@property NSArray*Stats;
//-(NSArray*)Stats;
+(void)getAllCountry:(void (^)(NSArray *list, NSError *error))block;
-(void)getStates:(void (^)(NSArray *list, NSDictionary *error))block;
//-(NSArray*)getAllCountyForSate;
-(void)getAllCountyForSate:(void (^)(NSArray *list, NSDictionary *error))block;
@end
