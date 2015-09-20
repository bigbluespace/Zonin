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
#import "MarqueeLabel.h"
#import "Zonin.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface HomeViewController (){
    MarqueeLabel *scrollyLabel;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeLowerviewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnConstraint;
@property (weak, nonatomic) IBOutlet UIView *newsLabelView;

@end

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

    if (IPAD) {
        _homeLowerviewConstraint.constant = 75;
        _adViewHeightConstraint.constant = 150;
        _headerViewConstraint.constant = 160;
        _menuBtnConstraint.constant = 48;
    }
    
    scrollyLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 20) rate:50.0 andFadeLength:10.0f];
    scrollyLabel.tag = 101;
    scrollyLabel.marqueeType = MLContinuous;
    //scrollyLabel.scrollDuration = 15.0;
    scrollyLabel.animationCurve = UIViewAnimationOptionCurveEaseInOut;
    scrollyLabel.rate = 40.0f;
    scrollyLabel.fadeLength = 10.0f;
    scrollyLabel.leadingBuffer = 40.0f;
    scrollyLabel.trailingBuffer = 40.0f;
    scrollyLabel.textColor = [UIColor whiteColor];
    scrollyLabel.textAlignment = NSTextAlignmentCenter;
    scrollyLabel.text = @"This is another long label that scrolls at a specific rate, rather than scrolling its length in a defined time window!";
    
    [_newsLabelView addSubview:scrollyLabel];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *params = @{
                             @"MACHINE_CODE" : @"emran4axiz"
                             };
    [Zonin commonPost:@"get_news_ticker/emran4axiz" parameters:params block:^(NSDictionary *JSON, NSError *error) {
        if([[JSON valueForKey:@"message"] isEqualToString:@"success"]){
            
            NSArray *newsArray = [JSON valueForKey:@"status"];
            NSString *newsString = [[NSMutableString alloc] init];
            for (int i = 0; i < newsArray.count; i++) {
                newsString = [newsString stringByAppendingString:[NSString stringWithFormat:@"%@    ",newsArray[i]]];
            }
            scrollyLabel.text = newsString;
        }
    }];
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
