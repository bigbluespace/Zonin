//
//  About.m
//  Zonin
//
//  Created by Rezaul Karim on 16/8/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "About.h"
#import "RESideMenu.h"
#import "Zonin.h"
#import "AboutSupportController.h"
#import "AdViewObject.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface About (){
    NSString *page_type;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewHeightConstraint;

@end

@implementation About{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBarHidden = YES;
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    if (IPAD) {
        _shareBtnHeightConstraint.constant = 240;
        _aboutHeightConstraint.constant = 82;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
#pragma mark - Button Click Event
- (IBAction)aboutUsBtn:(id)sender {
    page_type = @"get_about_us";
    [self performSegueWithIdentifier:@"aboutSupportSegue" sender:self];
}
- (IBAction)privacyPolicy:(id)sender {
    page_type = @"get_privacy_policy";
    [self performSegueWithIdentifier:@"aboutSupportSegue" sender:self];
    
}

- (IBAction)disclaimerBtn:(id)sender {
    page_type = @"get_affiliate";
    [self performSegueWithIdentifier:@"aboutSupportSegue" sender:self];
}

- (IBAction)serviceAgreementBtn:(id)sender {
    page_type = @"get_press_news";
    [self performSegueWithIdentifier:@"aboutSupportSegue" sender:self];
}

- (IBAction)communityGuidlines:(id)sender {
    page_type = @"get_send_feedback";
    [self performSegueWithIdentifier:@"aboutSupportSegue" sender:self];
}

- (IBAction)contactUsBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"contactSupportSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"aboutSupportSegue"]) {
        ((AboutSupportController*)segue.destinationViewController).pageType = page_type;
    }
}


@end
