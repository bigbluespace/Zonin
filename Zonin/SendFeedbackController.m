//
//  SendFeedbackController.m
//  Zonin
//
//  Created by Rezaul Karim on 4/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "SendFeedbackController.h"
#import "MBProgressHUD.h"
#import "Zonin.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface SendFeedbackController (){
    BOOL valid;
    UIView *tintView;
    UILabel* toolbarTitle;
    NSMutableArray *textFieldArray;
    
    CGFloat PORTRAIT_KEYBOARD_HEIGHT, animatedDistance, KEYBOARD_ANIMATION_DURATION;
    float origin;
    UIToolbar *toolBar;
    NSInteger currentIndex, tempIndex, currentRank;
    id currentField;
}
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UIView *feedBackgroudView;

@end

@implementation SendFeedbackController

//static NSInteger kKeyboardTintViewTag = 1234;

- (void)viewDidLoad {
    [super viewDidLoad];
    valid = YES;
    [[UITextField appearance] setTintColor:[UIColor redColor]];
    
    [self createToolbar];

    textFieldArray = [[NSMutableArray alloc] initWithArray:@[_nameText, _emailText, _phoneText, _feedbackTextView]];
    for (UITextField *text in textFieldArray) {
        [self setViewPicker:text];
    }
    _feedBackgroudView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    
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
    
    toolbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 100, 21.0f)];
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
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendBtn:(id)sender {
    NSString *name, *email, *phone, *feedback;
    name = _nameText.text;
    email = _emailText.text;
    phone = _phoneText.text;
    feedback = _feedbackTextView.text;
    
    if ([name isEqualToString:@""] && [email isEqualToString:@""] && [feedback isEqualToString:@""]) {
        valid = NO;
    }
    if (valid) {
        NSDictionary *dict = @{
                               @"name" : name,
                               @"email" : email,
                               @"phone" : phone,
                               @"feedback" : feedback,
                               @"MACHINE_CODE": @"emran4axiz"
                               };
        [Zonin commonPost:@"http://zoninapp.com/admin/backend/api_zonin/email_feedback/emran4axiz" parameters:dict block:^(NSDictionary *JSON, NSError *error) {
            if ([[JSON valueForKey:@"message"] isEqualToString:@"success"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[JSON valueForKey:@"status"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    currentField = textField;
    NSUInteger index = [textFieldArray indexOfObject:textField];
    if (index != NSNotFound) {
        currentIndex = index;
        
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
#pragma mark - UITextView Delegate
-(BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    currentField = textView;
    NSUInteger index = [textFieldArray indexOfObject:textView];
    if (index != NSNotFound) {
        currentIndex = index;
        
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    [self animateView_Up:&textFieldRect];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
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
    [[textFieldArray objectAtIndex:currentIndex] becomeFirstResponder];
    
}
-(void) previous{
    tempIndex = currentIndex;
    if(currentIndex>0){
        currentIndex--;
    }else{
        currentIndex = textFieldArray.count-1;
    }
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
