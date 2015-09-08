//
//  HotNews.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/15/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "HotNews.h"
#import "UWebOparetion.h"
#import "Zonin.h"


@implementation HotNews

//-----------------------------
/*+(NSArray*)allhotNews
{
    //get_hot_news
    
   
    NSMutableArray* hotnews=[[NSMutableArray alloc]init];
    NSDictionary *postData = @{
                               @"MACHINE_CODE" : @"emran4axiz"
                               };
    [Zonin commonPost:@"get_hot_news" parameters:postData block:^(NSDictionary *dataDic, NSError *error) {
        if ([[dataDic valueForKey:@"message"] isEqualToString:@"success"] && error==nil) {
            
            if ([[dataDic objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
            {
                NSLog(@"data found");
                NSDictionary* hotnewsDic=[dataDic objectForKey:JSON_KEY_STATUS];
                for (NSDictionary* news in hotnewsDic)
                {
                    HotNews * temp=[[HotNews alloc]init];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_title=[news objectForKey:key_news_title];
                    temp.news_desc=[news objectForKey:key_news_desc];
                    temp.news_file=[news objectForKey:key_news_file];
                    temp.country_id=[[news objectForKey:key_country_id]integerValue];
                    temp.hot_news_id=[[news objectForKey:key_hot_news_id]integerValue];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_date=[news objectForKey:key_news_date];
                    [hotnews addObject:temp];
                    
                }
            }
            else
            {
                HotNews * temp=[[HotNews alloc]init];
                temp.news_desc=[dataDic objectForKey:JSON_KEY_ERROR];
            }
        }
    }];
    
   //  UWebOparetion*webOP=[[UWebOparetion alloc]init];
   // NSArray*field=[[NSArray alloc]initWithObjects:@"MACHINE_CODE",nil];
   // NSArray*value=[[NSArray alloc]initWithObjects:MACHINE_CODE,nil];
  //  NSData* data=[webOP sendDataByPostWithFieldName:field andValue:value forWebPage:get_hot_news];
  //  NSDictionary*dataDic=[webOP parseJESONObjectFromData:data];
   
   
    
    return hotnews;
}
 */
//-------------------------
+(NSArray *)NewsBySearchUsingFeilds:(NSArray *)fields andValue:(NSArray *)Value
{
    NSMutableArray* hotnews=[[NSMutableArray alloc]init];
    UWebOparetion*webOP=[[UWebOparetion alloc]init];
    //NSArray*field=[[NSArray alloc]initWithObjects:@"MACHINE_CODE",nil];
   // NSArray*value=[[NSArray alloc]initWithObjects:MACHINE_CODE,nil];
    NSData* data=[webOP sendDataByPostWithFieldName:fields andValue:Value forWebPage:get_hot_news];
    NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data is %@",myString);
    NSDictionary*dataDic=[webOP parseJESONObjectFromData:data];
    if (!dataDic)
    {
        return nil;
    }
    if ([[dataDic objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
    {
        NSLog(@"data found");
        NSDictionary* hotnewsDic=[dataDic objectForKey:JSON_KEY_STATUS];
        for (NSDictionary* news in hotnewsDic)
        {
            HotNews * temp=[[HotNews alloc]init];
            temp.news_date=[news objectForKey:key_news_date];
            temp.news_title=[news objectForKey:key_news_title];
            temp.news_desc=[news objectForKey:key_news_desc];
            temp.news_file=[news objectForKey:key_news_file];
            temp.country_id=[[news objectForKey:key_country_id]integerValue];
             temp.hot_news_id=[[news objectForKey:key_hot_news_id]integerValue];
            temp.news_date=[news objectForKey:key_news_date];
            temp.news_date=[news objectForKey:key_news_date];
            temp.news_date=[news objectForKey:key_news_date];
            temp.news_date=[news objectForKey:key_news_date];
            temp.news_date=[news objectForKey:key_news_date];
            temp.news_date=[news objectForKey:key_news_date];
            [hotnews addObject:temp];
            
        }
    }
    else
    {
        HotNews * temp=[[HotNews alloc]init];
        temp.news_desc=[dataDic objectForKey:JSON_KEY_ERROR];
    }
    return hotnews;
}
//-------------------------------------
//
-(NSArray *)Feedback
{
    NSMutableArray*feedback=[[NSMutableArray alloc]init];
    UWebOparetion*webOP=[[UWebOparetion alloc]init];
    NSArray*field=[[NSArray alloc]initWithObjects:@"MACHINE_CODE",nil];
     NSArray*value=[[NSArray alloc]initWithObjects:MACHINE_CODE,nil];
    NSString*address=[NSString stringWithFormat:@"%@/%d/%@",All_in_hot_news,self.hot_news_id,MACHINE_CODE];
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
         NSDictionary* hotnewsDic=[dataDic objectForKey:JSON_KEY_STATUS];
         NSDictionary* FeedbackDic=[hotnewsDic objectForKey:@"hot_news_feedback"];
        NSLog(@"feedback found00 %d",FeedbackDic.count);
        for (NSDictionary* feed in FeedbackDic)
        {
            Feedback* temp=[[Feedback alloc]init];
            temp.feedback=[feed objectForKey:@"news_feedback"];
            temp.feedback_id=[[feed objectForKey:@"news_feedback_id"]integerValue];
            [feedback addObject:temp];
        }
        
    }
    return feedback;
}
//---------------------
@end
