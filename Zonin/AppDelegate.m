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
<<<<<<< HEAD
=======
#import <GooglePlus/GooglePlus.h>
>>>>>>> origin/master

@import AVFoundation;

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString * const kClientId = @"377172623921-pt41gensge64e34u6389os3na5p9u23h.apps.googleusercontent.com";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GPPSignIn sharedInstance].clientID = kClientId;

    // Read Google+ deep-link data.
    
    return YES;
}
-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"url %@", url);
    if (url != nil)
    {
        
<<<<<<< HEAD
        //return [[FBSession activeSession] handleOpenURL:url];
=======
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
>>>>>>> origin/master
    }
    
    return NO;
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
<<<<<<< HEAD
   //  [[FBSession activeSession] handleDidBecomeActive];
=======
     //[[FBSession activeSession] handleDidBecomeActive];
>>>>>>> origin/master
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   // [[FBSession activeSession] close];
}

@end
