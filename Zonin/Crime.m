//
//  Crime.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "Crime.h"
#import "UWebOparetion.h"
#import "AppDelegate.h"

@implementation Crime
+(NSArray *)getAllCrime
{
    NSMutableArray* crimes=[[NSMutableArray alloc]init];
    __block NSString* alertmgs;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"MACHINE_CODE": MACHINE_CODE
                                 };
    [manager POST:get_crime parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSDictionary*datadic=(NSDictionary*)responseObject;
         NSLog(@"json:%@",responseObject);
         if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             NSDictionary* crimedic=[responseObject objectForKey:JSON_KEY_STATUS];
             for (NSDictionary* crime in crimedic)
             {
                 Crime*temp=[[Crime alloc]init];
                 temp.crime_date=[crime objectForKey:@"crime_date"];
                 temp.crime_title=[crime objectForKey:@"crime_title"];
                 temp.crime_location=[crime objectForKey:@"crime_location"];
                 temp.country_name=[crime objectForKey:@"country_name"];
                 temp.state_name=[crime objectForKey:@"state_name"];
                 temp.report_date=[crime objectForKey:@"report_date"];
                 temp.report_time=[crime objectForKey:@"report_time"];
                 temp.User_email=[crime objectForKey:@"email"];
                 temp.crime_desc=[crime objectForKey:@"crime_desc"];
                 temp.state_name=[crime objectForKey:@"state_name"];
                 temp.crime_id=[[crime objectForKey:@"crime_id"]intValue];
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
//----------------------------------------------
-(NSArray *)getFeedback
{
   NSMutableArray*feedback=[[NSMutableArray alloc]init];
    
    UWebOparetion*webOP=[[UWebOparetion alloc]init];
    NSArray*field=[[NSArray alloc]initWithObjects:@"MACHINE_CODE",nil];
    NSArray*value=[[NSArray alloc]initWithObjects:MACHINE_CODE,nil];
    NSString*address=[NSString stringWithFormat:@"%@/%d/%@",get_All_in_crime,self.crime_id,MACHINE_CODE];
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
        NSDictionary* FeedbackDic=[statusdic objectForKey:@"crime_feedback"];
        NSLog(@"feedback found00 %d",FeedbackDic.count);
      
        for (NSDictionary* feed in FeedbackDic)
        {
            Feedback* temp=[[Feedback alloc]init];
            temp.feedback=[feed objectForKey:@"crime_report"];
            temp.feedback_id=[[feed objectForKey:@"crime_feedback_id"]intValue];
            temp.email=[feed objectForKey:@"email"];
            temp.f_name=[feed objectForKey:@"f_name"];
            temp.l_name=[feed objectForKey:@"l_name"];
            [feedback addObject:temp];
        }
    }
   
    return feedback;
}
//--------------------------------------------
-(void)addFeedback:(NSString *)feedback
{
    __block NSString* alertmgs;
    AppDelegate*myAppdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{@"user_id":[NSString stringWithFormat:@"%d", myAppdelegate.logedUser.userID],
                                 @"crime_id":[NSString stringWithFormat:@"%d", self.crime_id],
                                 @"crime_report": feedback,
                                 @"MACHINE_CODE": MACHINE_CODE
                                 };
    [manager POST:add_crime_feedback parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
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
