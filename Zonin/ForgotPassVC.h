//
//  ForgotPassVC.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/25/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "App-Utilities.h"
#import "KeyboardToolbar.h"

@interface ForgotPassVC : UIViewController<KeyboardToolbarDelegates>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterEmail;
//@property (weak, nonatomic) IBOutlet UIView *varifyCodeView;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode;
//
//set new pass
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPass_1;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPass_2;

//@property (weak, nonatomic) IBOutlet UIView *SetNewPasswordView;

@end
