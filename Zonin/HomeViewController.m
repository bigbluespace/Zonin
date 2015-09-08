//
//  HomeViewController.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/15/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "HomeViewController.h"
#import "RESideMenu.h"
#import "AdViewObject.h"

@implementation HomeViewController
{
    UIView*SpinnerView;
    __weak IBOutlet UIView *adView;
}

-(void)viewDidLoad
{
    SpinnerView=[[UIView alloc]initWithFrame:self.backgroundImageView.bounds];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"zonin_logo"] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBarHidden = YES;
    
     AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];

}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

//
//sortyboard segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    [self spinnerShow];
//    if ([segue.identifier isEqualToString:@"newslist"]) {
//       
//        NewsListVC *destViewController = segue.destinationViewController;
//        destViewController.hotNewsCollection=[HotNews allhotNews];
//        //send hot news view controller any information if nedded
//        //
//    }
//    [self spinnerOff];
}
//
//spinner function
//------------------------
-(void)spinnerShow
{
    
    [self.backgroundImageView addSubview:SpinnerView ];
    SpinnerView.backgroundColor=[UIColor clearColor];
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=SpinnerView.center;
    [SpinnerView addSubview:activityView];
    [activityView startAnimating];
    activityView.backgroundColor=[UIColor blueColor];
//    [UIView animateWithDuration:0.2
//                     animations:^{SpinnerView.alpha = 1.0;}
//                     completion:nil];
}
-(void)spinnerOff
{
    [UIView animateWithDuration:0.8
                     animations:^{SpinnerView.alpha = 0.0;}
                     completion:^(BOOL finished){ [SpinnerView removeFromSuperview]; }];
}

@end
