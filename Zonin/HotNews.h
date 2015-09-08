//
//  HotNews.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/15/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App-Utilities.h"
#import "Feedback.h"

@interface HotNews : NSObject
@property NSString* country_name;
@property int country_id;
@property int hot_news_id;
@property NSString* hot_news_popularity;
@property NSString* news_file;
@property NSString* news_title;
@property NSString* news_date;
@property NSString* state_name;
@property int state_id;
@property NSString* news_desc;
@property NSString* hot_news_country_id;
@property NSString* created_time;
//@property NSString* news_image_file;
@property NSDictionary*newsFeedback;
//functions
//+(NSArray*)allhotNews;
+(NSArray*)NewsBySearchUsingFeilds:(NSArray*)fields andValue:(NSArray*)Value;
+(HotNews*)NewsbyID:(int)id;
-(NSArray*)Feedback;
@end
