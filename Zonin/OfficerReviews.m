//
//  OfficerReviews.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/12/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.


#import "OfficerReviews.h"

@implementation OfficerReviews
+(NSArray *)GetAllReview
{
    NSMutableArray* crimes=[[NSMutableArray alloc]init];
    __block NSString* alertmgs;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"MACHINE_CODE": MACHINE_CODE
                                 };
    [manager POST:get_review parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSDictionary*datadic=(NSDictionary*)responseObject;
         NSLog(@"json:%@",responseObject);
         if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             NSDictionary* crimedic=[responseObject objectForKey:JSON_KEY_STATUS];
             for (NSDictionary* crime in crimedic)
             {
                 OfficerReviews*temp=[[OfficerReviews alloc]init];
                 temp.review_county_id=[[crime objectForKey:@"review_county_id"]intValue];
                 temp.review_date=[crime objectForKey:@"review_date"];
                 temp.review_id=[[crime objectForKey:@"review_id"]intValue];
                 temp.review_text=[crime objectForKey:@"review_text"];
                 temp.review_for=[crime objectForKey:@"review_for"];
                 //
                 temp.review_rating=[[NSString stringWithFormat:@"%@",[crime objectForKey:@"review_rating"]]intValue];
                 temp.officer_name=[crime objectForKey:@"review_officer_name"];
                 temp.country_name=[crime objectForKey:@"country_name"];
                 temp.state_name=[crime objectForKey:@"state_name"];
                 temp.review_details=[crime objectForKey:@"review_details"];
                 temp.f_name=[crime objectForKey:@"f_name"];
                 temp.l_name=[crime objectForKey:@"l_name"];
                 temp.agency=[crime objectForKey:@"agency"];
               //  temp.review_text=[crime objectForKey:@"review_text"];
                 
                 [crimes addObject:temp];
             }
             //[self TostAlertMsg:alertmgs];
         }
         else
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             if (!alertmgs)
             {
                 alertmgs=[responseObject objectForKey:JSON_KEY_ERROR];
             }
             // [self TostAlertMsg:alertmgs];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         alertmgs=[error localizedDescription];
         //[self TostAlertMsg:alertmgs];
     }];
    return crimes;
}
//-------------------------
-(NSArray*)getFeedback
{
        NSMutableArray*feedback=[[NSMutableArray alloc]init];
        
        UWebOparetion*webOP=[[UWebOparetion alloc]init];
        NSArray*field=[[NSArray alloc]initWithObjects:@"MACHINE_CODE",nil];
        NSArray*value=[[NSArray alloc]initWithObjects:MACHINE_CODE,nil];
        NSString*address=[NSString stringWithFormat:@"%@/%d/%@",get_all_in_review,self.review_id,MACHINE_CODE];
        NSData* data=[webOP sendDataByPostWithFieldName:field andValue:value forWebPage:address];
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"data is %@",myString);
        NSDictionary*dataDic=[webOP parseJESONObjectFromData:data];
        if (!dataDic)
        {
            return nil;
        }
        if ([[dataDic objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
        {
            NSDictionary* statusdic=[dataDic objectForKey:JSON_KEY_STATUS];
            NSDictionary* FeedbackDic=[statusdic objectForKey:@"review_feedback"];
            NSLog(@"feedback found00 %d",FeedbackDic.count);
            
            for (NSDictionary* feed in FeedbackDic)
            {
                
                Feedback* temp=[[Feedback alloc]init];
                temp.feedback=[feed objectForKey:@"review_feedback_desc"];
                temp.feedback_id=[[feed objectForKey:@"review_feedback_id"]intValue];
                temp.email=[feed objectForKey:@"email"];
                temp.f_name=[feed objectForKey:@"f_name"];
                temp.l_name=[feed objectForKey:@"l_name"];
                [feedback addObject:temp];
            }
        }
        
        return feedback;
}
//
//------------------------
-(void)addFeedback:(NSString *)feedback andRating:(float)rating andUserID:(int)userid
{
    __block NSString* alertmgs;
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{@"user_id":[NSString stringWithFormat:@"%d", userid],
                                 @"review_id":[NSString stringWithFormat:@"%d", self.review_id],
                                 @"review_feedback_desc": feedback,
                                 @"review_rating": [NSString stringWithFormat:@"%f",rating],
                                 @"MACHINE_CODE": MACHINE_CODE
                                 };
    [manager POST:add_review_feedback parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSDictionary*datadic=(NSDictionary*)responseObject;
         NSLog(@"json:%@",responseObject);
         if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             
             [self TostAlertMsg:alertmgs];
         }
         else
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             if (!alertmgs)
             {
                 alertmgs=[responseObject objectForKey:JSON_KEY_ERROR];
             }
             [self TostAlertMsg:alertmgs];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         alertmgs=[error localizedDescription];
         [self TostAlertMsg:alertmgs];
     }];

}
//------------------------
//---------------
//showig tost
-(void)TostAlertMsg:(NSString*)alertmsg
{
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertmsg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

@end
