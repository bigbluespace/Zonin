//
//  AdViewObject.m
//  Zonin
//
//  Created by Rezaul Karim on 6/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "AdViewObject.h"
#import "Zonin.h"


#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

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
        NSInteger height = 100;;
        if (IPAD) {
            height = 150;
        }
        
        self.adView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, height)];
        self.adView.userInteractionEnabled = YES;
        self.adView.image = [UIImage imageNamed:@"home_background"];
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:self.adView.frame];
        [addButton addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.adView addSubview:addButton];
        [self fetchAdd:[Zonin readData:@"settingData"]];
        
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged:) name:@"settingsChanged" object:nil];
        
    }
    return self;
}
- (void)fetchAdd:(NSDictionary*)dic{
    
    NSLog(@"[Zonin readData  %@", dic);
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:@{
                            @"MACHINE_CODE" : @"emran4axiz"
                            }];
    if (dic != nil && dic != (id) [NSNull null]) {
        [param setObject:[dic valueForKey:@"country_id"] forKey:@"country_id"];
        [param setObject:[dic valueForKey:@"state_id"] forKey:@"state_id"];
        [param setObject:[dic valueForKey:@"county_id"] forKey:@"county_id"];
    }
    
    
    [Zonin commonPost:@"get_advertisement/emran4axiz" parameters:param block:^(NSDictionary *JSON, NSError *error) {
        self.adArray = [JSON valueForKey:@"status"];
        [self.adView setImageWithURL:[NSURL URLWithString:[self.adArray[0] valueForKey:@"media_url"]]];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                      target:self
                                                    selector:@selector(targetMethod)
                                                    userInfo:nil
                                                     repeats:YES];
    }];
}
- (void)settingsChanged:(NSNotification *)notification {
    
    NSDictionary *settingsParam = [notification valueForKey:@"userInfo"];
    [self fetchAdd:settingsParam];

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
