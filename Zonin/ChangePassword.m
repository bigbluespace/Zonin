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

@interface ChangePassword ()

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (IBAction)cancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
