//
//  ChangePassword.m
//  Zonin
//
//  Created by Rezaul Karim on 11/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "ChangePassword.h"
#import "RESideMenu.h"
#import "AdViewObject.h"
#import "Zonin.h"
#import "MBProgressHUD.h"

@interface ChangePassword (){
    NSString *recentPass, *newPass, *confirmPass, *user_id;
}

@property (weak, nonatomic) IBOutlet UITextField *recentPassText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassText;

@end

@implementation ChangePassword{
    AppDelegate* myAppDelegate;
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITextField appearance] setTintColor:[UIColor redColor]];
    myAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBarHidden = YES;
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    
    UIView *paddingTxtfieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 42)];
    _recentPassText.leftView = paddingTxtfieldView;
    _recentPassText.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingTxtfieldView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 42)];
    _passText.leftView = paddingTxtfieldView2;
    _passText.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingTxtfieldView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 42)];
    _confirmPassText.leftView = paddingTxtfieldView3;
    _confirmPassText.leftViewMode = UITextFieldViewModeAlways;
    
    NSDictionary *auth = [Zonin readData:@"user_id"];
    user_id = [auth valueForKey:@"user_id"];//[[[NSUserDefaults alloc] init] valueForKey:@"user_id"];
    NSLog(@"%@", [auth valueForKey:@"user_id"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - UIButton Event
- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (IBAction)cancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitPassBtn:(id)sender {
    recentPass = _recentPassText.text;
    newPass = _passText.text;
    confirmPass = _confirmPassText.text;
    
    if (recentPass.length > 5 && newPass.length > 5 && confirmPass.length > 5) {
        if ([newPass isEqualToString:confirmPass]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self saveDataToServer];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"New Password & Confirm Password does not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please fill all the field before procced." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark - Save Data To Server
-(void)saveDataToServer{
    NSDictionary *dict = @{
                           @"MACHINE_CODE" : @"emran4axiz",
                           @"user_id" :  user_id,
                           @"password" : recentPass,
                           @"new_password" : newPass
                           };
    NSString *url = [NSString stringWithFormat:@"http://zoninapp.com/admin/backend/api_zonin/changePassword/emran4axiz"];
    
    [Zonin commonPost:url parameters:dict block:^(NSDictionary *JSON, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"JSON %@", JSON);
    }];
    
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
