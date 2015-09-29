//
//  ContactSupportController.m
//  Zonin
//
//  Created by Rezaul Karim on 2/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "ContactSupportController.h"
#import "RESideMenu.h"
#import "Zonin.h"
#import "MBProgressHUD.h"
#import "AdViewObject.h"

@interface ContactSupportController ()
@property (weak, nonatomic) IBOutlet UIWebView *webContentView;

@end

@implementation ContactSupportController{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webContentView.backgroundColor = [UIColor clearColor];
    _webContentView.opaque = NO;
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    [self loadPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)loadPages{
    NSDictionary *dict = @{
                           @"MACHINE_CODE" : @"emran4axiz"
                           };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Zonin commonPost:@"http://zoninapp.com/admin/backend/api_zonin/get_contact_us/emran4axiz" parameters:dict block:^(NSDictionary *JSON, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[JSON valueForKey:@"message"] isEqualToString:@"success"]) {
            NSArray *status = [JSON valueForKey:@"status" ];
            NSString *html = [status[0] valueForKey:@"contact_us"];
            NSString *state = [NSString stringWithFormat:@"<html><head></head><body style=\"color:#fff\">%@</body></html>",html];
            NSLog(@"%@", state);
            [_webContentView loadHTMLString:state baseURL:nil];
        }
    }];
}

- (IBAction)ratingApplication:(UIButton *)sender {
    NSString *url = @"itms-apps://itunes.apple.com/app/id1033251065";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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
