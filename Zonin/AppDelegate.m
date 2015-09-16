//
//  AppDelegate.m
//  Zonin
//
//  Created by MD UDDIN on 6/7/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
//#import <FacebookSDK/FacebookSDK.h>

@import AVFoundation;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    self.logedUser=[[User alloc]init];
    
    
    
//    NSURL* mMovieURL;
//    NSBundle *bundle = [NSBundle mainBundle];
//    if(bundle != nil)
//    {
//        NSString *moviePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"videostart.mp4"];
//        if (moviePath)
//        {
//            mMovieURL = [NSURL fileURLWithPath:moviePath];
//           
//        }
//    }
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    self.mMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:mMovieURL];
//    
//     self.mMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:mMovieURL];
//   
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:self.mMoviePlayer.moviePlayer];
//    self.mMoviePlayer.moviePlayer.controlStyle = MPMovieControlStyleNone;
//   // [mMoviePlayer.moviePlayer.backgroundView  addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]]];
//    self.mMoviePlayer.moviePlayer.scalingMode = MPMovieScalingModeFill;
//    self.window.rootViewController=  self.mMoviePlayer;
//
//    
//    [self.mMoviePlayer.moviePlayer setFullscreen:YES animated:NO];
//    [self.mMoviePlayer.moviePlayer prepareToPlay];
//    [self.mMoviePlayer.moviePlayer play];
    
 /*   NSString *url = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"videostart.mp4"];
    
    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(movieFinishedCallback:)
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:[playerViewController moviePlayer]];
    
    self.window.rootViewController = playerViewController;
    
    //play movie
    
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    
    [player play];*/
    
    
    return YES;
}
-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (url != nil)
    {
        
        //return [[FBSession activeSession] handleOpenURL:url];
    }
    
    return NO;
}
- (void)moviePlayBackDidFinish{
    
   // MPMoviePlayerController *player = [aNotification object];
//    [[NSNotificationCenter defaultCenter]
//     removeObserver:self
//     name:MPMoviePlayerPlaybackDidFinishNotification
//     object:player];
    
    //player.initialPlaybackTime = -1;
    //[player pause];
//    [player stop];
    
//    [player.view removeFromSuperview];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   //  [[FBSession activeSession] handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   // [[FBSession activeSession] close];
}

@end
