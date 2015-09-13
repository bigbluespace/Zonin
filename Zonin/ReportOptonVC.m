//
//  ReportOptonVC.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/12/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "ReportOptonVC.h"
#import "RESideMenu.h"
#import "AdViewObject.h"

@interface ReportOptonVC ()

@end

@implementation ReportOptonVC{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationController.navigationBarHidden = YES;
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
//-------------------------------
- (IBAction)vewcrimereport:(id)sender {
    NSLog(@"view report ....");
    ReportReviewVC*reviewlist=[self.storyboard instantiateViewControllerWithIdentifier:@"reportlistvc"];
    reviewlist.isCrimeReport = YES;
    [self.navigationController pushViewController:reviewlist animated:YES];
    
}
//------------------------------------
- (IBAction)viewReviews:(id)sender {
    NSLog(@"view review ....");
    ReportReviewVC*reviewlist=[self.storyboard instantiateViewControllerWithIdentifier:@"reportlistvc"];
    reviewlist.isCrimeReport = NO;
    [self.navigationController pushViewController:reviewlist animated:YES];
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
