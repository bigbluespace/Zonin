//
//  App-Utilities.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/15/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef Zonin_App_Utilities_h
#define Zonin_App_Utilities_h


#endif
//json keys
#define JSON_KEY_STATUS                    @"status"
#define JSON_KEY_ERROR                     @"error"
#define JSON_KEY_MESSAGE                   @"message"
#define SERVER_MESSAGE_SUCCESS             @"success"
//hot news
#define key_country_name            @"country_name"
#define key_country_id              @"country_id"
#define key_hot_news_id             @"hot_news_id"
#define key_news_feedback           @"news_feedback"
#define key_hot_news_popularity     @"hot_news_popularity"
#define key_news_file               @"news_file"
#define key_news_title              @"news_title"
#define key_news_date               @"news_date"
#define key_state_name              @"state_name"
#define key_state_id                @"state_id"
#define key_county_state_name       @"county_name"
#define key_county_state_id         @"id"
#define key_news_desc               @"news_desc"
#define key_hot_news_county_id      @"hot_news_county_id"
#define key_created_time            @"created_time"
#define key_user_id                 @"usre_id"
//news file prefix
#define News_fileURL_prefix             @"http://zoninapp.com/admin/upload/hot_news_files/"
//
//seever function link
#define MACHINE_CODE                       @"emran4axiz"
#define user_registration                  @"http://zoninapp.com/admin/backend/api_zonin/user_registration"
#define get_login                          @"http://zoninapp.com/admin/backend/api_zonin/get_login"
#define account_reverification             @"http://zoninapp.com/admin/backend/api_zonin/account_reverification"
#define sendPasswordRequest                @"http://zoninapp.com/admin/backend/api_zonin/sendPasswordRequest"
#define resetPassword                      @"http://zoninapp.com/admin/backend/api_zonin/resetPassword"

#define add_hot_news_feedback              @"http://zoninapp.com/admin/backend/api_zonin/add_hot_news_feedback"

//review
#define get_review                         @"http://zoninapp.com/admin/backend/api_zonin/get_review"
#define get_all_in_review                  @"http://zoninapp.com/admin/backend/api_zonin/get_all_in_review"
#define add_review                         @"http://zoninapp.com/admin/backend/api_zonin/add_review"
#define add_review_feedback                @"http://zoninapp.com/admin/backend/api_zonin/add_review_feedback"
//hot news
#define get_recent_hot_news                @"http://zoninapp.com/admin/backend/api_zonin/get_recent_hot_news"
#define get_hot_news                       @"http://zoninapp.com/admin/backend/api_zonin/get_hot_news"
#define get_next_hot_news                  @"http://zoninapp.com/admin/backend/api_zonin/get_next_hot_news"
#define All_in_hot_news                   @"http://zoninapp.com/admin/backend/api_zonin/get_all_in_hot_news/"
//12 crime
#define add_crime                          @"http://zoninapp.com/admin/backend/api_zonin/add_crime"
#define add_crime_feedback                 @"http://zoninapp.com/admin/backend/api_zonin/add_crime_feedback"
#define get_crime                          @"http://zoninapp.com/admin/backend/api_zonin/get_crime"
#define get_All_in_crime                   @"http://zoninapp.com/admin/backend/api_zonin/get_all_in_crime"
//34
#define get_countries                      @"http://zoninapp.com/admin/backend/api_zonin/get_countries/emran4axiz"
#define get_states_under_country           @"http://zoninapp.com/admin/backend/api_zonin/get_states_under_country"
#define get_county_underState              @"http://zoninapp.com/admin/backend/api_zonin/get_county_under_state_under_country"
#define isCodeTrue                         @"http://zoninapp.com/admin/backend/api_zonin/isCodeTrue"

//
//iphone version and utilitys
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
//
//hot news page utilitis

