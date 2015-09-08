//
//  rootViewViewController.m
//  Zonin
//
//  Created by Arif on 9/7/14.
//  Copyright (c) 2014 Trena. All rights reserved.
//

#import "rootViewViewController.h"

@interface rootViewViewController ()

@end

@implementation rootViewViewController

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//   // NSLog(@"preferredInterfaceOrientationForPresentation");
//    return UIInterfaceOrientationPortrait;
//}
//
//-(BOOL) shouldAutorotate {
//   //   NSLog(@"shouldAutorotate");
//    NSString *activeViewController = NSStringFromClass(((UINavigationController*)self.contentViewController).topViewController.class);
//    
//    if([activeViewController isEqualToString:@"PhotoDisplay"])
//        return YES;
//    else if(!UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])){
//    //    NSLog(@"hihi");
//        return YES;
//    }
//    return NO;
//}


//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    NSString *activeViewController = NSStringFromClass(((UINavigationController*)self.contentViewController).topViewController.class);
//    
//    if([activeViewController isEqualToString:@"PhotoDisplay"]){
//        return UIInterfaceOrientationMaskAll;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}



- (void)awakeFromNib
{
    
//    _animationDuration = 0.35f;
//    _interactivePopGestureRecognizerEnabled = YES;
//    
//    _menuViewControllerTransformation = CGAffineTransformMakeScale(1.5f, 1.5f);
//    
//    _scaleContentView = YES;
//    _scaleBackgroundImageView = YES;
//    _scaleMenuView = YES;
//    
//    _parallaxEnabled = YES;
//    _parallaxMenuMinimumRelativeValue = -15;
//    _parallaxMenuMaximumRelativeValue = 15;
//    _parallaxContentMinimumRelativeValue = -25;
//    _parallaxContentMaximumRelativeValue = 25;
//    
//    _bouncesHorizontally = YES;
//    
//    _panGestureEnabled = YES;
//    _panFromEdge = YES;
//    _panMinimumOpenThreshold = 60.0;
//    
//    _contentViewShadowEnabled = NO;
//    _contentViewShadowColor = [UIColor blackColor];
//    _contentViewShadowOffset = CGSizeZero;
//    _contentViewShadowOpacity = 0.4f;
//    _contentViewShadowRadius = 8.0f;
//    _contentViewInLandscapeOffsetCenterX = 30.f;
//    _contentViewInPortraitOffsetCenterX  = 30.f;
//    _contentViewScaleValue = 0.7f;
    
    

    self.parallaxEnabled  = NO;
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    self.contentViewScaleValue = 1.0f;
    self.contentViewInPortraitOffsetCenterX = 75.0f;
    self.contentViewShadowEnabled = NO;
    self.animationDuration = 0.2f;
    self.menuViewControllerTransformation = CGAffineTransformMakeScale(1.2f, 1.2f);
    self.panGestureEnabled = NO;
    
    
    // check if the user is already logged in..
    //  NSDictionary *auth = (NSDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:@"auth"];
    
    //    User *user = [[User alloc] initWithProperties:auth];
    // if (user.userID > 0) {
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:220.0/255.0 green:16.0/255.0 blue:77.0/255.0 alpha:1.0]];
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    // check if the user is already logged in..

//    NSError* error;
//    NSInteger UserID = 0;
//    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth"];
//    if (data != nil) {
//        NSDictionary* User = [NSJSONSerialization
//                              JSONObjectWithData:data
//                              options:kNilOptions
//                              error:&error];
//        
//        UserID = [[User valueForKeyPath:@"id"] integerValue];
//    }
//
//    if ( UserID > 0) {
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewStoryboard"];
//    } else {
//        self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewStoryboard"];
//        
//    }
    
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuController"];
    
   // self.rightMenuViewController = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SavedSearchView"]];
    
   // self.rightMenuViewController = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SavedSearchList"]];
    
   // self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewStoryboard"];
   //self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewStoryboard"];
   // self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];

   // self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuController"];

    
    
    //    } else {
    //
    //        self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewStoryboard"];
    //
    //    }
   // self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewStoryboard"];
    
    //self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    
    //   self.backgroundImage = [UIImage imageNamed:@"slideMenu"];
    
    self.delegate = self;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController{
    //NSLog(@"willShowMenuViewController1: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController{
    if ([NSStringFromClass([menuViewController class]) isEqualToString:@"UINavigationController"]) {
      
    }
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController{
    if ([NSStringFromClass([menuViewController class]) isEqualToString:@"UINavigationController"]) {
        
    }
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController{
    //NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
   // [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
        view.backgroundColor=[UIColor blackColor];
        [self.view addSubview:view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
