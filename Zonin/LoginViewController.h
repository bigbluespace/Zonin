//
//  LoginViewController.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/25/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "App-Utilities.h"
#import "AppDelegate.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <QuartzCore/QuartzCore.h>

@class GPPSignInButton;

@interface LoginViewController : UIViewController<UITextFieldDelegate,GPPSignInDelegate>

@property (weak, nonatomic) IBOutlet GPPSignInButton *googleSignInButton;


@property (weak, nonatomic) IBOutlet UIView *ContainerView;
@property (weak, nonatomic) IBOutlet UIView *registerView;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
//register view fields
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailreg;
@property (weak, nonatomic) IBOutlet UITextField *txtPasswordreg;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *genderTxt;


@end
