//
//  Country.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/17/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "Country.h"

@implementation Country

+(void)getAllCountry:(void (^)(NSArray *list, NSError *error))block {
    
    NSMutableArray* counteylist=[[NSMutableArray alloc]init];
    UWebOparetion*webOP=[[UWebOparetion alloc]init];
    NSArray*field=[[NSArray alloc]initWithObjects:@"MACHINE_CODE",nil];
    NSArray*value=[[NSArray alloc]initWithObjects:MACHINE_CODE,nil];
    NSData* data=[webOP sendDataByPostWithFieldName:field andValue:value forWebPage:get_countries];
    NSDictionary*dataDic=[webOP parseJESONObjectFromData:data];
    if (!dataDic)
    {
        block(nil, nil);
    }
    if ([[dataDic objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
    {
        NSLog(@"data found");
        NSDictionary* countryDic=[dataDic objectForKey:JSON_KEY_STATUS];
        for (NSDictionary* country in countryDic)
        {
            Country *temp=[[Country alloc]init];
            temp.Name=[country objectForKey:key_country_name];
            temp.country_id=[[country objectForKey:key_country_id]integerValue];
            [counteylist addObject:temp];
            
        }
    }
    else
    {
        ;
    }
    block(counteylist, nil);
}

//-(NSArray*)Stats
-(void)getStates:(void (^)(NSArray *list, NSDictionary *error))block {

    NSMutableArray* statslist=[[NSMutableArray alloc]init];
    UWebOparetion*webOP=[[UWebOparetion alloc]init];
    NSArray*field=[[NSArray alloc]initWithObjects:@"MACHINE_CODE",nil];
    NSArray*value=[[NSArray alloc]initWithObjects:MACHINE_CODE,nil];
    NSString* address=[NSString stringWithFormat:@"%@/%d/%@",get_states_under_country,self.country_id,MACHINE_CODE];
    NSData* data=[webOP sendDataByPostWithFieldName:field andValue:value forWebPage:address];
    NSDictionary*dataDic=[webOP parseJESONObjectFromData:data];
    if (!dataDic)
    {
         block(nil, nil);
    }
    if ([[dataDic objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
    {
        NSLog(@"data found");
        NSDictionary* countryDic=[dataDic objectForKey:JSON_KEY_STATUS];
        for (NSDictionary* country in countryDic)
        {
            Country*temp=[[Country alloc]init];
            temp.Name=[country objectForKey:key_state_name];
            temp.country_id=[[country objectForKey:key_state_id]integerValue];
            [statslist addObject:temp];
            
        }
        block(statslist, nil);
    }
    else
    {
        block(nil, dataDic);
 
    }
    self.Stats=statslist;
    //return statslist;
   
}
    
    
-(void)getAllCountyForSate:(void (^)(NSArray *list, NSDictionary *error))block {
//-(NSArray*)getAllCountyForSate
//{
    NSMutableArray* countylist=[[NSMutableArray alloc]init];
    UWebOparetion*webOP=[[UWebOparetion alloc]init];
    NSArray*field=[[NSArray alloc]initWithObjects:@"MACHINE_CODE",nil];
    NSArray*value=[[NSArray alloc]initWithObjects:MACHINE_CODE,nil];
    NSString* address=[NSString stringWithFormat:@"%@/%d/%@",get_county_underState,self.country_id,MACHINE_CODE];
    NSData* data=[webOP sendDataByPostWithFieldName:field andValue:value forWebPage:address];
    NSDictionary*dataDic=[webOP parseJESONObjectFromData:data];
    if (!dataDic)
    {
        block(nil, nil);
    }
    if ([[dataDic objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
    {
        NSLog(@"data found");
        NSDictionary* countryDic=[dataDic objectForKey:JSON_KEY_STATUS];
        for (NSDictionary* country in countryDic)
        {
            Country*temp=[[Country alloc]init];
            temp.Name=[country objectForKey:key_county_state_name];
            temp.country_id=[[country objectForKey:key_county_state_id]integerValue];
            [countylist addObject:temp];
            
        }
        block(countylist,nil);
    }
    else
    {
//        Country*temp=[[Country alloc]init];
//        temp.Name=@"not found";
//        temp.country_id=0;
//        [countylist addObject:temp];
        block(nil, dataDic);
    }
   
    //return countylist;
    
}
@end
