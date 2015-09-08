//
//  AppDelegate.h
//  Zonin
//
//  Created by MD UDDIN on 6/7/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@import MediaPlayer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property User* logedUser;

@property MPMoviePlayerViewController *mMoviePlayer;

@end

