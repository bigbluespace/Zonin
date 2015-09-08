//
//  Crime.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App-Utilities.h"
#import "AFNetworking.h"
#import "Feedback.h"

@interface Crime : NSObject
@property NSString* crime_title;
@property NSString*crime_location;
@property NSString* crime_date;
@property NSString* country_name;
@property NSString*state_name;
@property NSString* crime_desc;
@property NSString* User_email;
@property NSString* report_date;
@property NSString* report_time;
@property int country_id;
@property int state_id;
@property int county_id;
@property int crime_id;
+(NSArray*)getAllCrime;
+(Crime*)getCrimeByID:(int)crime_id;
// JSon is not structure for all (new,crime,review) feadback. so now i will use dictionary.
-(NSArray*)getFeedback;
-(void)addFeedback:(NSString*)feedback;
@end
