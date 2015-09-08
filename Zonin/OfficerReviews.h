//
//  OfficerReviews.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/12/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "App-Utilities.h"
#import "Feedback.h"
#import "UWebOparetion.h"

@interface OfficerReviews : NSObject
@property int review_id;
@property int country_id;
@property int review_state_id;
@property int review_county_id;
@property int review_zip_code;
@property NSString* review_for;
@property NSString* review_text;
@property NSString* review_date;
@property NSString* country_name;
@property NSString* county_name;
@property NSString* email;
@property NSString* f_name;
@property NSString* is_admin;
@property NSString* l_name;
@property int officer_id;
@property NSString* officer_name;
@property NSString* phone_no;
@property NSString* review_details;
@property float review_rating;
@property NSString* state_name;
@property NSString* vehicle_no;
@property NSString* agency;

//@property NSString* review_feedback_id;
//@property NSString* review_rating;
//@property NSString* review_feedback_desc;

//class functions
+(NSArray*)GetAllReview;
-(NSArray*)getFeedback;
-(void)addFeedback:(NSString*)feedback andRating:(float)rating andUserID:(int)userid;
@end
