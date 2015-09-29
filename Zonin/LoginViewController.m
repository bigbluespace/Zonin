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
#import "Zonin.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <QuartzCore/QuartzCore.h>
#import "Zonin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

static NSString * const kClientId = @"377172623921-pt41gensge64e34u6389os3na5p9u23h.apps.googleusercontent.com";

@interface LoginViewController ()
{
    UIView*SpinnerView;
    AppDelegate* myAppDelegate;
    __weak IBOutlet UIView *adView;
    BOOL isLogin;
    
    
    
   
    //UIPickerView* optionPicker;
    UIPickerView* myPickerView;
    UILabel* toolbarTitle;
    
    
    NSMutableArray* fieldList;
    NSMutableArray* pickerArrayList;
    NSMutableArray* pickerTitleList;
    
    NSMutableArray* currentArray;
    UITextField* currentField;
    NSInteger currentIndex;
    
    NSInteger tempIndex;
    
    CGFloat PORTRAIT_KEYBOARD_HEIGHT;
    
    float origin;
    CGFloat animatedDistance;
    CGFloat KEYBOARD_ANIMATION_DURATION ;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITextField appearance] setTintColor:[UIColor redColor]];
    SpinnerView=[[UIView alloc]initWithFrame:self.ContainerView.bounds];
    self.registerView.hidden=YES;
    myAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBarHidden = YES;
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    
    UIView *paddingTxtfieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 42)];
    _txtEmail.leftView = paddingTxtfieldView;
    _txtEmail.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingTxtfieldView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 42)];
    _txtPassword.leftView = paddingTxtfieldView2;
    _txtPassword.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    isLogin = YES;
    if (IPAD) {
        
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    _googleSignInButton.colorScheme = kGPPSignInButtonColorSchemeLight;
    _googleSignInButton.style = kGPPSignInButtonStyleIconOnly;
    _googleLogin.colorScheme = kGPPSignInButtonColorSchemeLight;
    _googleLogin.style = kGPPSignInButtonStyleIconOnly;
    
    [GPPSignInButton class];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    
    //[signIn disconnect];
    //[signIn signOut];
    
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    
    signIn.clientID = kClientId;
    signIn.scopes = @[ kGTLAuthScopePlusLogin, @"profile"];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.delegate = self;
    
}

- (IBAction)fbLogin:(id)sender {
    [self loginButtonClicked];
}

-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    //login.readPermissions =  @[@"email"];
    [login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"fb result %@", result.token.userID);
             NSLog(@"Logged in");
             //
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email, name"}]
               startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                   
                   if (!error) {
                      // NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
                       
                       
                       
                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc]
                                                          initWithDictionary: @{
                                                                                @"EMAIL": result[@"email"],
                                                                                @"MACHINE_CODE": MACHINE_CODE
                                                                                }];
                       NSString *url = @"get_login";
                       if (!isLogin) {
                           
                           [parameters setObject:result[@"name"] forKey:@"F_NAME"];
                           [parameters setObject:@"" forKey:@"L_NAME"];
                           url = @"user_registration";
                       }
                       
                       
                       __block NSString* alertmgs;
                       
                       [Zonin commonPost:url parameters:parameters block:^(NSDictionary *responseObject, NSError *error) {
                           if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
                           {
                               
                               NSString *user_id = [responseObject valueForKey:@"user_id"];
                               if (user_id == nil || user_id == (id)[NSNull null]) {
                                   user_id = [responseObject valueForKey:@"usre_id"];
                               }
                               NSDictionary *dict = @{
                                                      @"user_id": user_id
                                                      };
                               [Zonin storeData:dict storageName:@"user_id"];
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
                           
                       }];
                       
                       
                       
                       
                       
                   }
               }];
             
             
         }
         
     }];
}

#pragma mark - Google+ Login
-(void)googlePlusLoginInit{

   
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    
    if ([GPPSignIn sharedInstance].authentication) {
        NSLog( @"Status: Authenticated");
        GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
        
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]
                                           initWithDictionary: @{
                                                                 @"EMAIL": [GPPSignIn sharedInstance].userEmail,
                                                                @"MACHINE_CODE": MACHINE_CODE
                                     }];
        NSString *url = @"get_login";
        if (!isLogin) {
            
            [parameters setObject:person.displayName forKey:@"F_NAME"];
            [parameters setObject:@"" forKey:@"L_NAME"];
            url = @"user_registration";
        }
        
        
        __block NSString* alertmgs;
        
        [Zonin commonPost:url parameters:parameters block:^(NSDictionary *responseObject, NSError *error) {
            if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
            {
                
                NSString *user_id = [responseObject valueForKey:@"user_id"];
                if (user_id == nil || user_id == (id)[NSNull null]) {
                    user_id = [responseObject valueForKey:@"usre_id"];
                }
                NSDictionary *dict = @{
                                       @"user_id": user_id
                                       };
                [Zonin storeData:dict storageName:@"user_id"];
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
            
        }];
        
    } else {
        
        NSLog(@"Status: Not authenticated");
    }
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Status: Failed to disconnect: %@", error);
        
        [self TostAlertMsg:[NSString stringWithFormat:@"Status: Failed to disconnect: %@", error]];
    } else {
        
        NSLog(@"Status: Disconnected");
        [self TostAlertMsg:@"Status: Disconnected"];
    }
}


//Register with Google
- (IBAction)googlePlusLogin:(UIButton*)sender {
    isLogin = NO;
   
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
    isLogin = NO;
    [self isNotlogincontrolShow:YES];
    self.txtFirstName.text=@"";
    self.txtLastName.text=@"";
    self.txtPasswordreg.text=@"";
    self.txtEmailreg.text=@"";
    self.txtPhone.text=@"";
    self.registerView.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

//------------------------------
- (IBAction)loginwithGoogle:(id)sender
{
    isLogin = YES;
    
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
    
    isLogin = YES;
    self.registerView.hidden=YES;
     [self isNotlogincontrolShow:NO];
}
//-------------------------------
- (IBAction)CancelTouch:(id)sender
{
    isLogin = YES;
    self.registerView.hidden = YES;
    [self isNotlogincontrolShow:NO];
}
//------------------------------
//signup
-(void)signUpWithName:(NSString*)name LastName:(NSString*)lname Email:(NSString*)email phone:(NSString*)phone andpass:(NSString*)pass
{
    //[self spinnerShow];
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
             
             NSString *user_id = [responseObject valueForKey:@"usre_id"];
             NSDictionary *dict = @{
                                    @"user_id": user_id
                                    };
             [Zonin storeData:dict storageName:@"user_id"];
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
    
    
}

//--------------------------------
-(void)getLoginwith:(NSString*)email andpass:(NSString*)pass
{
    //[self spinnerShow];
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
        if ([[responseObject valueForKey:@"message"] isEqualToString:@"success"])
        {
            alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
            myAppDelegate.logedUser.userID=[[responseObject objectForKey:key_user_id]integerValue];
            
            NSString *user_id = [responseObject valueForKey:@"usre_id"];
            NSDictionary *dict = @{
                                   @"user_id": user_id
                                   };
            [Zonin storeData:dict storageName:@"user_id"];
            
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
