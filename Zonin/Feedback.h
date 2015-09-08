//
//  Feedback.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/5/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feedback : NSObject
@property NSString* email;
@property NSString* f_name;
@property NSString* l_name;
@property NSString* feedback;
@property NSString* phone;
@property int feedback_id;
@property int news_id;
@property int user_id;
@property float review_rating;//use only for review feedback
@end
