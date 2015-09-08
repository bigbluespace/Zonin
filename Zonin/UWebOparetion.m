//
//  UWebOparetion.m
//  symptom-monitor
//
//  Created by Arifuzzaman likhon on 8/7/14.
//  Copyright (c) 2014 ubitrix. All rights reserved.
//

#import "UWebOparetion.h"

@implementation UWebOparetion
{
    NSString *DataString;
    NSData* returndata;
}
-(NSData*)sendDataByPostWithFieldName:(NSArray *)FieldName andValue:(NSMutableArray *)Value forWebPage:(NSString *)webpage
{
    DataString=@"";
    if(FieldName.count==Value.count)
    {
         //NSLog(@"data string is if");
        for (int i=0; i<FieldName.count; i++)
        {
         DataString=[DataString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",[FieldName objectAtIndex:i],[Value objectAtIndex:i]]];
            NSLog(@"data string is %@",DataString);
        }
       NSMutableData *postData=(NSMutableData*)[DataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *dataLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:webpage]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:dataLength forHTTPHeaderField:@"info"];
        [request setHTTPBody:postData];
        NSHTTPURLResponse *response = nil;
     
        if ([self isConnected])
        {
            returndata =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
           
           // [self parseJESONObjectFromData:returndata];
            
        }
        else
        {
            UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please connect to intenet" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        
        }
 
    }
    else
    {
        NSLog(@"Unequal field and value");
    }
    return returndata;
}
//--------------------------fil
-(NSData*)sendDataByPostWithFieldNameAndFile:(NSArray *)FieldName andValue:(NSMutableArray *)Value forWebPage:(NSString *)webpage andFile:(NSString*)Filename
{
    DataString=@"";
    if(FieldName.count==Value.count)
    {
        //NSLog(@"data string is if");
        for (int i=0; i<FieldName.count; i++)
        {
            DataString=[DataString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",[FieldName objectAtIndex:i],[Value objectAtIndex:i]]];
            NSLog(@"data string is %@",DataString);
        }
        NSMutableData *postData=(NSMutableData*)[DataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *dataLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=%@",Filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
         NSData* data=[NSData dataWithContentsOfFile:Filename];
        [body appendData:[NSData dataWithData:data]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:body];
        [request setURL:[NSURL URLWithString:webpage]];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        NSHTTPURLResponse *response = nil;
        
        if ([self isConnected])
        {
            returndata =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
            
            // [self parseJESONObjectFromData:returndata];
            
        }
        else
        {
            UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please connect to intenet" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }
    else
    {
        NSLog(@"Unequal field and value");
    }
    return returndata;
}

// for parse jeson object
// nsdata parametter consis of jeson object
// return dictonary of parsed object
-(NSDictionary *)parseJESONObjectFromData:(NSData *)Data
{
    NSDictionary *parsedObject;
    NSString* responseStr=[[NSString alloc]initWithData:Data encoding:NSUTF8StringEncoding];
    //NSLog(responseStr);
 
    @try
    {

        NSError *localError = nil;
        parsedObject = [NSJSONSerialization JSONObjectWithData:Data options:0 error:&localError];
        
        if (localError != nil) {
            NSLog(@"error occure:%@",localError);
        }
        else
        {
            NSLog(@"message %@",[parsedObject objectForKey:@"message"]);
            NSLog(@"status %@",[parsedObject objectForKey:@"status"]);
            NSLog(@"error: %@",[parsedObject objectForKey:@"error"]);
           // NSLog(@"mess %@ and count %d",[parsedObject objectForKey:@"message"],[parsedObject count]);
        }

    }
    @catch (NSException *exception)
    {
        NSLog(@"exception occured");
        [self TostAlertMsg:@"An Error occure while connecting to server."];
        return nil;
    }
    @finally
    {
        
    }
       return  parsedObject;
    
}
//tost mgs
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
// this function check web connectivity
// return type bool
// true is for web connectivity , flase is for not
-(BOOL)isConnected
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus ==NotReachable)
    {
        NSLog(@"There IS no internet connection");
        return FALSE;
    }
    else
    {
        NSLog(@"There IS internet connection");
        return true;
    }
    //return true;
}
@end
