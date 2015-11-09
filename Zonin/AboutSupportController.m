//
//  AboutSupportControllerViewController.m
//  Zonin
//
//  Created by Rezaul Karim on 1/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "AboutSupportController.h"
#include "RESideMenu.h"
#import "Zonin.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AdViewObject.h"

@interface AboutSupportController ()
@property (weak, nonatomic) IBOutlet UIWebView *aboutContentWeb;
@property (weak, nonatomic) IBOutlet UIWebView *adsWebView;

@end

@implementation AboutSupportController{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _aboutContentWeb.backgroundColor = [UIColor clearColor];
    _aboutContentWeb.opaque = NO;
    NSLog(@"%@", _pageType);
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    
    [self loadPages];
}

- (IBAction)headerClicked:(id)sender {
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"home"]]
                                                 animated:YES];
    
}
-(void)loadPages{
    NSDictionary *dict = @{
                           @"MACHINE_CODE" : @"emran4axiz"
                           };
    
    NSString *url_str = [NSString stringWithFormat:@"http://zoninapp.com/admin/backend/api_zonin/%@/emran4axiz", _pageType];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Zonin commonPost:url_str parameters:dict block:^(NSDictionary *JSON, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[JSON valueForKey:@"message"] isEqualToString:@"success"]) {
            NSArray *status = [JSON valueForKey:@"status" ];
            NSString *page = [_pageType stringByReplacingOccurrencesOfString:@"get_" withString:@""];
            NSString *html = [status[0] valueForKey:page];
            NSString *state = [NSString stringWithFormat:@"<html><head></head><body style=\"color:#fff\">%@</body></html>",html];
            NSLog(@"%@", state);
            [_aboutContentWeb loadHTMLString:state baseURL:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
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
