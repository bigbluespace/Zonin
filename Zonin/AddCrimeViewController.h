//
//  AddCrimeViewController.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/23/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AddCrimeView.h"

@interface AddCrimeViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//@property (weak, nonatomic) IBOutlet UIView *reviewContainer;
@property Country*currentCountry;
@property Country*currentState;
@property Country*currentParish;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageVew;
@property (weak, nonatomic) IBOutlet UIView *containerView;


@end
