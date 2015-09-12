//
//  AdViewObject.m
//  Zonin
//
//  Created by Rezaul Karim on 6/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "AdViewObject.h"
#import "Zonin.h"

@implementation AdViewObject
+ (id)sharedManager {
    static AdViewObject *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.adView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
        self.adView.userInteractionEnabled = YES;
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:self.adView.frame];
        [addButton addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
        //addButton.backgroundColor = [UIColor redColor];
        [self.adView addSubview:addButton];
        
        
//        UITapGestureRecognizer *singleFingerTap =
//        [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                action:@selector(handleSingleTap:)];
//        singleFingerTap.numberOfTapsRequired = 1;
//        [self.adView addGestureRecognizer:singleFingerTap];
        NSDictionary *param = @{
                                @"MACHINE_CODE" : @"emran4axiz"
                                };
        
        [Zonin commonPost:@"get_advertisement/emran4axiz" parameters:param block:^(NSDictionary *JSON, NSError *error) {
            self.adArray = [JSON valueForKey:@"status"];
            [self.adView setImageWithURL:[NSURL URLWithString:[self.adArray[0] valueForKey:@"media_url"]]];
            
        
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                          target:self
                                                        selector:@selector(targetMethod)
                                                        userInfo:nil
                                                         repeats:YES];
            
            
            
            
            NSLog(@"json  %@", JSON);
            
        }];
        
        
    }
    return self;
}

- (void) targetMethod{
    self.counter++;
    if (self.counter >= self.adArray.count) {
        self.counter = 0;
    }
    [self.adView setImageWithURL:[NSURL URLWithString:[self.adArray[self.counter] valueForKey:@"media_url"]]];
}

- (IBAction)handleSingleTap:(id)sender {
    NSString *url = [self.adArray[self.counter] valueForKey:@"advertise_url"];
    if ([url rangeOfString:@"http://"].location == NSNotFound && [url rangeOfString:@"https://"].location == NSNotFound) {
        url = [@"http://" stringByAppendingString:url];
    }
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
