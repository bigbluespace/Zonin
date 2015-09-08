//
//  LoginViewController.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/25/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "LoginViewController.h"
#import "RESideMenu.h"
#import "AdViewObject.h"

@interface LoginViewController ()
{
    UIView*SpinnerView;
    AppDelegate* myAppDelegate;
    __weak IBOutlet UIView *adView;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SpinnerView=[[UIView alloc]initWithFrame:self.ContainerView.bounds];
    self.registerView.hidden=true;
    myAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBarHidden = YES;
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    // Do any additional setup after loading the view.
}
//---------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
//---------------------------------
//button functions
- (IBAction)btnLoginTouch:(id)sender
{
    NSString*pass=self.txtPassword.text;
    [self getLoginwith:[self.txtEmail.text lowercaseString] andpass:pass];
}
//-----------------------------
- (IBAction)RegisterTouch:(id)sender
{
    [self isNotlogincontrolShow:YES];
    self.txtFirstName.text=@"";
    self.txtLastName.text=@"";
    self.txtPasswordreg.text=@"";
    self.txtEmailreg.text=@"";
    self.txtPhone.text=@"";
    self.registerView.hidden=false;
}
-(void)isNotlogincontrolShow:(BOOL)action
{
    for (UIView*a in [self.ContainerView subviews])
    {
        if ([a isKindOfClass:[UIButton class]]||[a isKindOfClass:[UITextField class]])
        {
            a.hidden=action;
        }
    }
}
//------------------------------
- (IBAction)forgotPssTouch:(id)sender {
}
//----------------------------
- (IBAction)loginWithfacebook:(id)sender
{
}
//------------------------------
- (IBAction)loginwithGoogle:(id)sender
{
}
//-----------------------------
- (IBAction)signuptouch:(id)sender
{
    NSString*name=[self.txtFirstName.text stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceCharacterSet]];
    NSString*lastname=[self.txtLastName.text stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceCharacterSet]];
    NSString*email=[self.txtEmailreg.text stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]];
    NSString*phone=[self.txtPhone.text stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]];
    NSString*pass=[self.txtPasswordreg.text stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]];
    [self signUpWithName:name LastName:lastname Email:email phone:phone andpass:pass];
    
    
    self.registerView.hidden=true;
     [self isNotlogincontrolShow:NO];
}
//-------------------------------
- (IBAction)CancelTouch:(id)sender
{
    self.registerView.hidden=true;
    [self isNotlogincontrolShow:NO];
}
//------------------------------
//signup
-(void)signUpWithName:(NSString*)name LastName:(NSString*)lname Email:(NSString*)email phone:(NSString*)phone andpass:(NSString*)pass
{
    [self spinnerShow];
    __block NSString* alertmgs;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{@"F_NAME": name,
                                 @"L_NAME": lname,
                                 @"PHONE_NO": phone,
                                 @"EMAIL": [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                                 @"PASSWORD": [pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                                 @"MACHINE_CODE": MACHINE_CODE
                                 };
    [manager POST:user_registration parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSDictionary*datadic=(NSDictionary*)responseObject;
         NSLog(@"json:%@",responseObject);
         if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             
             [self TostAlertMsg:alertmgs];
         }
         else
         {
             
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             if (!alertmgs)
             {
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
    [self spinnerOff];
    
    
}

//--------------------------------
-(void)getLoginwith:(NSString*)email andpass:(NSString*)pass
{
    [self spinnerShow];
    __block NSString* alertmgs;
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{@"EMAIL": [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                                 @"PASSWORD": [pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                                 @"MACHINE_CODE": MACHINE_CODE
                                 };
    [manager POST:get_login parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSDictionary*datadic=(NSDictionary*)responseObject;
        NSLog(@"json:%@",responseObject);
        if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
        {
            alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
            myAppDelegate.logedUser.userID=[[responseObject objectForKey:key_user_id]integerValue];
            NSLog(@"user id %d",myAppDelegate.logedUser.userID);
            [self TostAlertMsg:alertmgs];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
            if (!alertmgs)
            {
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
    [self spinnerOff];
    
}
//----------------------------------
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//spinner function
-(void)spinnerShow
{
    
    [self.ContainerView addSubview:SpinnerView ];
    SpinnerView.backgroundColor=[UIColor clearColor];
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=SpinnerView.center;
    [SpinnerView addSubview:activityView];
    [activityView startAnimating];
    activityView.backgroundColor=[UIColor blueColor];
    [UIView animateWithDuration:0.2
                     animations:^{SpinnerView.alpha = 1.0;}
                     completion:nil];
}
-(void)spinnerOff
{
    [UIView animateWithDuration:0.8
                     animations:^{SpinnerView.alpha = 0.0;}
                     completion:^(BOOL finished){ [SpinnerView removeFromSuperview]; }];
}
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
