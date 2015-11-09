//
//  ForgotPassVC.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/25/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "ForgotPassVC.h"
#import "RESideMenu.h"
#import "AdViewObject.h"

@interface ForgotPassVC (){
    UITextField *currentField;
    KeyboardToolbar *toolbarwithoutButton, *toolbarwithButton;
}
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *verificationView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@end

@implementation ForgotPassVC
{
    __weak IBOutlet UIView *adView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _emailView.hidden = NO;
    _verificationView.hidden = YES;
    _passwordView.hidden = YES;
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    
    toolbarwithoutButton = [[KeyboardToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    
    toolbarwithoutButton.delegate = self;
    self.txtEnterEmail.inputAccessoryView = toolbarwithoutButton;
    self.txtEnterEmail.keyboardAppearance = UIKeyboardAppearanceDark;
    
    self.txtVerifyCode.inputAccessoryView = toolbarwithoutButton;
    self.txtVerifyCode.keyboardAppearance = UIKeyboardAppearanceDark;
    
    
    self.txtEnterPass_1.inputAccessoryView = toolbarwithoutButton;
    self.txtEnterPass_1.keyboardAppearance = UIKeyboardAppearanceDark;
    
    
    self.txtEnterPass_2.inputAccessoryView = toolbarwithoutButton;
    self.txtEnterPass_2.keyboardAppearance = UIKeyboardAppearanceDark;
}
-(void)keyboardNext{
    if (currentField == self.txtEnterPass_1){
        [self.txtEnterPass_2 becomeFirstResponder];
    }else if(currentField == self.txtEnterPass_2){
        [self.txtEnterPass_1 becomeFirstResponder];
    }
}
-(void)keyboardPrevious{
    if (currentField == self.txtEnterPass_1){
        [self.txtEnterPass_2 becomeFirstResponder];
    }else if(currentField == self.txtEnterPass_2){
        [self.txtEnterPass_1 becomeFirstResponder];
    }
}
-(void)keyboardDone{
    [currentField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-------------------------------------
//button funtion
- (IBAction)btnSubmitEmail:(id)sender
{
    
    if ([self.txtEnterEmail.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please enter email addtess" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self AskingCodeforEmail:self.txtEnterEmail.text];
    //set all field empty
    self.txtVerifyCode.text=@"";
    self.txtEnterPass_1.text=@"";
    
    self.txtEnterPass_2.text=@"";
    [currentField resignFirstResponder];
}
//--------------------------------------
- (IBAction)VerifyCodeTouch:(id)sender
{
    if ([self.txtVerifyCode.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please enter verification code" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
        
    }
    [self VerifyCode:self.txtVerifyCode.text forEmail:[self.txtEnterEmail.text lowercaseString ]];
    [currentField resignFirstResponder];
}

//-------------------------------------
-(void)AskingCodeforEmail:(NSString*)Email
{
    __block NSString* alertmgs;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"EMAIL": [Email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                                 @"MACHINE_CODE": MACHINE_CODE
                                 };
    [manager POST:sendPasswordRequest parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSDictionary*datadic=(NSDictionary*)responseObject;
         NSLog(@"json:%@",responseObject);
         if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             //[self visibilityHidden:YES inview:self.contentView];
             
             _emailView.hidden = YES;
             _verificationView.hidden = NO;
             //[self visibilityHidden:NO inview:self.varifyCodeView];
             //[self TostAlertMsg:alertmgs];
         }
         else
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             if (!alertmgs) {
                 alertmgs=[responseObject objectForKey:JSON_KEY_ERROR];
             }
             [self TostAlertMsg:alertmgs];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         alertmgs=[error localizedDescription];
         [self TostAlertMsg:alertmgs];
     }];

}
//----------------------------------
-(void)VerifyCode:(NSString*)Code forEmail:(NSString*)email
{
    __block NSString* alertmgs;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    NSDictionary *parameters = @{@"CODE":Code,
                                 @"EMAIL": [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                                 @"MACHINE_CODE": MACHINE_CODE
                                 };
    [manager POST:isCodeTrue parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSDictionary*datadic=(NSDictionary*)responseObject;
         NSLog(@"json:%@",responseObject);
         if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
            // [self TostAlertMsg:alertmgs];
             //[self visibilityHidden:YES inview:self.varifyCodeView];
             //self.SetNewPasswordView.hidden=NO;
             _verificationView.hidden = YES;
             _passwordView.hidden = NO;
         }
         else
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             if (!alertmgs) {
                 alertmgs=[responseObject objectForKey:JSON_KEY_ERROR];
             }
             [self TostAlertMsg:alertmgs];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         alertmgs=[error localizedDescription];
         [self TostAlertMsg:alertmgs];
     }];
    
}
//-----------------------
//
- (IBAction)setNewpasswordTouch:(id)sender
{
    if ([self.txtEnterPass_1.text isEqualToString:@""] || [self.txtEnterPass_2.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please enter password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
        
    }
    if ([self.txtEnterPass_1.text isEqualToString:self.txtEnterPass_2.text])
    {
        NSString* pass=[self.txtEnterPass_1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self setpassWordforEmail:self.txtEnterEmail.text Pass:pass];
    }
    else
    {
        [self TostAlertMsg:@"Password not matched."];
    }
}
- (IBAction)menuButtonClick:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
-(void)setpassWordforEmail:(NSString*)email Pass:(NSString*)Pass
{
    __block NSString* alertmgs;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSDictionary *parameters = @{@"PASSWORD":Pass,
                                 @"EMAIL": [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                                 @"MACHINE_CODE": MACHINE_CODE
                                 };
    [manager POST:resetPassword parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSDictionary*datadic=(NSDictionary*)responseObject;
         NSLog(@"json:%@",responseObject);
         if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
              [self TostAlertMsg:alertmgs];
              [self visibilityHidden:NO inview:self.contentView];
             //self.SetNewPasswordView.hidden=YES;
             //self.varifyCodeView.hidden=YES;
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             if (!alertmgs) {
                 alertmgs=[responseObject objectForKey:JSON_KEY_ERROR];
             }
             [self TostAlertMsg:alertmgs];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         alertmgs=[error localizedDescription];
         [self TostAlertMsg:alertmgs];
     }];
    

    
}
//visibility hide or show
-(void)visibilityHidden:(BOOL)action inview:(UIView*)mView
{
    for (UIView*a in [mView subviews])
    {
        if ([a isKindOfClass:[UIButton class]]||[a isKindOfClass:[UITextField class]])
        {
            a.hidden=action;
        }
    }
}

#pragma mark - textfield delegates -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    currentField = textField;
    if (currentField == self.txtEnterEmail) {
        [toolbarwithoutButton setBarTitle:@"Email"];
        [toolbarwithoutButton hideLeftButtons:YES];
    }else if (currentField == self.txtVerifyCode){
        [toolbarwithoutButton setBarTitle:@"Enter Code"];
        [toolbarwithoutButton hideLeftButtons:YES];
    }else if (currentField == self.txtEnterPass_1){
        [toolbarwithoutButton setBarTitle:@"Password"];
        [toolbarwithoutButton hideLeftButtons:NO];
    }else if(currentField == self.txtEnterPass_2){
        [toolbarwithoutButton setBarTitle:@"Verify"];
        [toolbarwithoutButton hideLeftButtons:NO];
    }
    
    
    return YES;
}


- (IBAction)headerClicked:(id)sender {
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"home"]]
                                                 animated:YES];
    
}
//-----------------------------------
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//
//
//---------------
//showig tost
-(void)TostAlertMsg:(NSString*)alertmsg
{
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertmsg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}
@end
