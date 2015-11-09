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
    UIView *tintView;
    UILabel* toolbarTitle;
    NSMutableArray *textFieldArray, *textFieldTitleArray;
    
    CGFloat PORTRAIT_KEYBOARD_HEIGHT, animatedDistance, KEYBOARD_ANIMATION_DURATION;
    float origin;
    UIToolbar *toolBar;
    NSInteger currentIndex, tempIndex, currentRank;
    UITextField *currentField;
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
    
    [self createToolbar];
    
    textFieldArray = [[NSMutableArray alloc] initWithArray:@[_recentPassText, _passText, _confirmPassText]];
    textFieldTitleArray=[[NSMutableArray alloc] initWithArray:@[@"Recent Password", @"New Password", @"Confirm Password"]];
    for (UITextField *text in textFieldArray) {
        [self setViewPicker:text];
    }
    
    NSDictionary *auth = [Zonin readData:@"user_id"];
    user_id = [auth valueForKey:@"user_id"];//[[[NSUserDefaults alloc] init] valueForKey:@"user_id"];
    NSLog(@"%@", [auth valueForKey:@"user_id"]);
}

#pragma mark - Custom Toolbar & view
- (void)setViewPicker:(UITextField*)textField{
    textField.inputAccessoryView = toolBar;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    if ([textField isKindOfClass:[UITextField class]]){
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
}

-(void) createToolbar{
    PORTRAIT_KEYBOARD_HEIGHT = 270;
    origin = self.view.frame.origin.y;
    KEYBOARD_ANIMATION_DURATION = 0.3;
    
    UIButton *next_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    next_btn.frame = CGRectMake(0, 0, 30, 46);
    [next_btn setImage:[UIImage imageNamed:@"picker-next"] forState:UIControlStateNormal];
    [next_btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:next_btn];
    
    UIButton *prev_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    prev_btn.frame = CGRectMake(0, 0, 30, 46);
    [prev_btn setImage:[UIImage imageNamed:@"picker-prev"] forState:UIControlStateNormal];
    [prev_btn addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *pevButton = [[UIBarButtonItem alloc] initWithCustomView:prev_btn];
    
    toolbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 140, 21.0f)];
    [toolbarTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [toolbarTitle setBackgroundColor:[UIColor clearColor]];
    [toolbarTitle setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [toolbarTitle setText:@"Title"];
    [toolbarTitle setTextAlignment:NSTextAlignmentCenter];
    
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:toolbarTitle];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                   target:self action:@selector(done)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 20;
    
    NSArray *toolbarItems = [NSArray arrayWithObjects: pevButton, nextButton, flexibleItem, title, flexibleItem, doneButton, nil];
    
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, 0, 320, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setItems:toolbarItems];
    [toolBar setTintColor:[UIColor whiteColor]];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
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

- (IBAction)headerClicked:(id)sender {
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"home"]]
                                                 animated:YES];
    
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    currentField = textField;
    NSUInteger index = [textFieldArray indexOfObject:textField];
    if (index != NSNotFound) {
        currentIndex = index;
        toolbarTitle.text = textFieldTitleArray[currentIndex];
        
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    [self animateView_Up:&textFieldRect];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
// Catpure the picker view selection



- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateView_Down];
}
#pragma mark -  Toolbar button Event
-(void) next{
    
    tempIndex = currentIndex;
    if(currentIndex<textFieldArray.count-1){
        currentIndex++;
    }else{
        currentIndex = 0;
    }
    toolbarTitle.text = textFieldTitleArray[currentIndex];
    [[textFieldArray objectAtIndex:currentIndex] becomeFirstResponder];
    
}
-(void) previous{
    tempIndex = currentIndex;
    if(currentIndex>0){
        currentIndex--;
    }else{
        currentIndex = textFieldArray.count-1;
    }
    toolbarTitle.text = textFieldTitleArray[currentIndex];
    [[textFieldArray objectAtIndex:currentIndex] becomeFirstResponder];
}
-(void) done{
    if ([currentField isFirstResponder]) {
        [currentField resignFirstResponder];
    }
    
    [self textResignFirstResponder];
}

- (void)textResignFirstResponder{
    if (tintView != nil) {
        [tintView removeFromSuperview];
        tintView = nil;
    }
}

#pragma mark - animation functions
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
