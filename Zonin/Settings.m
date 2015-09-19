//
//  Settings.m
//  Zonin
//
//  Created by Rezaul Karim on 16/8/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "Settings.h"
#import "RESideMenu.h"
#import "AdViewObject.h"
#import "Zonin.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface Settings (){
    BOOL video;
    NSString *user_id;
}
@property (weak, nonatomic) IBOutlet UIButton *videoState;
@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;

@end

@implementation Settings{
     __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    video = YES;
    self.navigationController.navigationBarHidden = YES;
    NSDictionary *auth = [Zonin readData:@"user_id"];
    user_id = [auth valueForKey:@"user_id"];
    
    _logoutView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    if (IPAD) {
        _btnHeightConstraint.constant = 84;
        _headerHeightConstraint.constant = 160;
        _menuHeightConstraint.constant = 48;
        _adsHeightConstraint.constant = 150;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (IBAction)videoBtn:(id)sender {
    if (video) {
        [_videoState setTitle:@"Video Off" forState:UIControlStateNormal];
        video = NO;
    }else{
        [_videoState setTitle:@"Video On" forState:UIControlStateNormal];
        video = YES;
    }
}
//selectSettingsSegue
- (IBAction)selectSettings:(id)sender {
    if (user_id != nil && [user_id integerValue] !=0) {
        [self performSegueWithIdentifier:@"selectSettingsSegue" sender:self];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please login before proceed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)changePasswordBtn:(id)sender {
    if (user_id != nil && [user_id integerValue] !=0) {
        [self performSegueWithIdentifier:@"changePasswordSegue" sender:self];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please login before proceed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}



- (IBAction)LogoutBtn:(id)sender {
    if ([user_id integerValue] != 0 && user_id != nil) {
        _logoutView.hidden = NO;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You are not logged in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Logout Btn

- (IBAction)logoutOkBtn:(id)sender {
    _logoutView.hidden = YES;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)logoutCancelBtn:(id)sender {
    _logoutView.hidden = YES;
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
