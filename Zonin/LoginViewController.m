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
    UILabel *loginToolbarTitle, *registerToolbarTitle;
    
    
    NSMutableArray *loginFieldList, *registerFieldList;;
    NSMutableArray *genderArray;
    NSMutableArray *loginPickerTitleList, *registerPickerTitleList;
    
   // NSMutableArray* currentArray;
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
    
    
    PORTRAIT_KEYBOARD_HEIGHT = 270;
    origin = self.view.frame.origin.y;
    KEYBOARD_ANIMATION_DURATION = 0.3;
    
    [[UITextField appearance] setTintColor:[UIColor redColor]];
    SpinnerView=[[UIView alloc]initWithFrame:self.ContainerView.bounds];
    self.registerView.hidden=true;
    myAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBarHidden = YES;
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    
    [self uiLoginInitialization];
    
    isLogin = YES;
    
    
    if (IPAD) {
        
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateView_Down];
}

-(void) loginnext{
    tempIndex = currentIndex;
    if (isLogin) {
        if(currentIndex<loginFieldList.count-1){
            currentIndex++;
        }else{
            currentIndex = 0;
        }
        [[loginFieldList objectAtIndex:currentIndex] becomeFirstResponder];
    }else{
        if(currentIndex<registerFieldList.count-1){
            currentIndex++;
        }else{
            currentIndex = 0;
        }
        [[registerFieldList objectAtIndex:currentIndex] becomeFirstResponder];
    }
   
    
    
}
-(void) loginprevious{
    tempIndex = currentIndex;
    if (isLogin) {
        if(currentIndex>0){
            currentIndex--;
        }else{
            currentIndex = loginFieldList.count-1;
        }
        [[loginFieldList objectAtIndex:currentIndex] becomeFirstResponder];
    }else{
        if(currentIndex>0){
            currentIndex--;
        }else{
            currentIndex = registerFieldList.count-1;
        }
        [[registerFieldList objectAtIndex:currentIndex] becomeFirstResponder];
    }
    
}

-(void) logindone{
    [currentField resignFirstResponder];
}


- (void) uiLoginInitialization{
    
    loginFieldList = [[NSMutableArray alloc] initWithArray:@[self.txtEmail, self.txtPassword]];
    loginPickerTitleList = [[NSMutableArray alloc] initWithArray:@[@"Email", @"Password"]];
    genderArray = [[NSMutableArray alloc] initWithArray:@[@"Male", @"Female"]];
    
    registerFieldList = [[NSMutableArray alloc] initWithArray:@[self.userName, self.txtFirstName, self.txtLastName, self.genderTxt,self.txtPhone, self.txtEmailreg, self.txtPasswordreg]];
    registerPickerTitleList = [[NSMutableArray alloc] initWithArray:@[@"User Name", @"First Name", @"Last Name", @"Gender", @"Phone Number", @"Email", @"Password"]];
    
    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 216)];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    
    [[UIPickerView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"picker_bg"]]];
    
    UIButton *next_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    next_btn.frame = CGRectMake(0, 0, 30, 46);
    [next_btn setImage:[UIImage imageNamed:@"picker-next"] forState:UIControlStateNormal];
    [next_btn addTarget:self action:@selector(loginnext) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:next_btn];
    
    UIButton *prev_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    prev_btn.frame = CGRectMake(0, 0, 30, 46);
    [prev_btn setImage:[UIImage imageNamed:@"picker-prev"] forState:UIControlStateNormal];
    [prev_btn addTarget:self action:@selector(loginprevious) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *pevButton = [[UIBarButtonItem alloc] initWithCustomView:prev_btn];
    
    loginToolbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 100, 21.0f)];
    [loginToolbarTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [loginToolbarTitle setBackgroundColor:[UIColor clearColor]];
    [loginToolbarTitle setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [loginToolbarTitle setText:@"Title"];
    [loginToolbarTitle setTextAlignment:NSTextAlignmentCenter];
    
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:loginToolbarTitle];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                   target:self action:@selector(logindone)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 20;
    
    NSArray *toolbarItems = [NSArray arrayWithObjects: pevButton, nextButton, flexibleItem, title, flexibleItem, doneButton, nil];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     myPickerView.frame.size.height-50, 320, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setItems:toolbarItems];
    [toolBar setTintColor:[UIColor whiteColor]];
    //[toolBar setBarTintColor:[UIColor colorWithRed:22.0/255.0 green:110.0/255.0 blue:209.0/255.0 alpha:1.0]];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    
    
    self.txtEmail.inputAccessoryView = toolBar;
    [self setLeftView:self.txtEmail];
    
    
    self.txtPassword.inputAccessoryView = toolBar;
    [self setLeftView:self.txtPassword];
    
    for (int i = 0; i < registerFieldList.count; i++) {
        ((UITextField*)registerFieldList[i]).inputAccessoryView = toolBar;
        [self setLeftView:registerFieldList[i]];
    }
}

- (void)setLeftView:(UITextField*)textField{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    if (textField == self.genderTxt) {
        textField.inputView = myPickerView;
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

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return genderArray.count;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = genderArray[row] ;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}
//-----------------------
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.genderTxt.text = genderArray[row];

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
    if([self.txtEmail.text isEqualToString:@""] || [self.txtPassword.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please fill up all fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
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
    self.registerView.hidden = false;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    currentField = textField;
    if (isLogin) {
        NSUInteger index = [loginFieldList indexOfObject:textField];
        if (index != NSNotFound) {
            loginToolbarTitle.text = [loginPickerTitleList objectAtIndex:index];
            currentIndex = index;
        }
    }else {
        NSUInteger index = [registerFieldList indexOfObject:textField];
        if (index != NSNotFound) {
            loginToolbarTitle.text = [registerPickerTitleList objectAtIndex:index];
            currentIndex = index;
        }
    }
   
    return YES;
}
#pragma mark -animation functions
- (void)animateView_Up: (CGRect*)rect{
    CGFloat fieldBottom =rect->origin.y+rect->size.height;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGRect viewFrame = self.view.frame;
    
    // NSLog(@"%f",viewFrame.origin.y);
    // NSLog(@"%f",origin);
    
    if (fieldBottom<(screenHeight-PORTRAIT_KEYBOARD_HEIGHT) && viewFrame.origin.y == origin) {
        animatedDistance = 0;
        return;
    }    else{
        animatedDistance = fieldBottom - (screenHeight-PORTRAIT_KEYBOARD_HEIGHT);
    }
    
    [self aniamteFields:animatedDistance down:NO];
    
}
- (void) animateView_Down{
    [self aniamteFields:origin down:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    [self animateView_Up:&textFieldRect];
}
- (void)aniamteFields:(CGFloat)distance down:(BOOL)down{
    CGRect viewFrame = self.view.frame;
    if (down) {
        viewFrame.origin.y = distance;
    }else{
        viewFrame.origin.y -= distance;
    }
    
    if (viewFrame.origin.y > origin) {
        viewFrame.origin.y = origin;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
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
    isLogin = YES;
    
}
//-----------------------------
- (IBAction)signuptouch:(id)sender
{
    if([self.userName.text isEqualToString:@""]
       || [self.txtFirstName.text isEqualToString:@""]
       || [self.txtLastName.text isEqualToString:@""]
       || [self.genderTxt.text isEqualToString:@""]
       || [self.txtPhone.text isEqualToString:@""]
       || [self.txtEmailreg.text isEqualToString:@""]
       || [self.txtPasswordreg.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please fill up all fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    
    
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
    self.registerView.hidden=true;
     [self isNotlogincontrolShow:NO];
}
//-------------------------------
- (IBAction)CancelTouch:(id)sender
{
    isLogin = YES;
    self.registerView.hidden = true;
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
