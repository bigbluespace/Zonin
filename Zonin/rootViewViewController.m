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

- (void)awakeFromNib
{
    
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
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:220.0/255.0 green:16.0/255.0 blue:77.0/255.0 alpha:1.0]];
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewStoryboard"];
    
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuController"];
    
    self.delegate = self;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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
