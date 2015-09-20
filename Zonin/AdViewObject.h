//
//  AdViewObject.h
//  Zonin
//
//  Created by Rezaul Karim on 6/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit+AFNetworking.h"


@interface AdViewObject : NSObject


@property UIImageView *adView;
@property NSArray *adArray;
@property NSTimer *timer;
@property NSInteger counter;

+ (id)sharedManager;


@end




