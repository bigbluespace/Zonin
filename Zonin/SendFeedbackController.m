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

@interface SendFeedbackController (){
    BOOL valid;
    UIView *tintView;
    UILabel* toolbarTitle;
    NSMutableArray *fieldList;
}
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@end

@implementation SendFeedbackController

static NSInteger kKeyboardTintViewTag = 1234;

- (void)viewDidLoad {
    [super viewDidLoad];
    valid = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowTintedKeyboard:) name:UIKeyboardWillShowNotification object:nil];

    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _nameText.leftView = paddingView;
    _nameText.leftViewMode =  UITextFieldViewModeWhileEditing;
    
    _emailText.leftView = paddingView;
    _emailText.leftViewMode =  UITextFieldViewModeWhileEditing;
//
    _phoneText.leftView = paddingView;
    _phoneText.leftViewMode =  UITextFieldViewModeWhileEditing;
    
    [[UITextField appearance] setTintColor:[UIColor redColor]];
    
    //
    fieldList = [[NSMutableArray alloc] initWithArray:@[_nameText, _emailText, _phoneText, _feedbackTextView]];
    for (UITextField *text in fieldList) {
        text.keyboardAppearance = UIKeyboardAppearanceDark;
    }
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
            }
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self textResignFirstResponder];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Keyboard Notifications

- (void)textResignFirstResponder{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
    if (tintView != nil) {
        [tintView removeFromSuperview];
        tintView = nil;
    }
}

- (void) handleShowTintedKeyboard:(NSNotification*)notification {
    if (tintView != nil) {
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    
    // Get keyboard frames
    CGRect keyboardBeginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Get keyboard animation.
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Create animation.
    tintView = [[UIView alloc] initWithFrame:keyboardBeginFrame];
    tintView.tag = kKeyboardTintViewTag;
    tintView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"keyboard_bg"]];
    [self.view addSubview:tintView];
    
    // Begin animation.
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         tintView.frame = keyboardEndFrame;
                     }
                     completion:^(BOOL finished) {}];
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
