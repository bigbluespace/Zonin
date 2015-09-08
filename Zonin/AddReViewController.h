//
//  AddReViewController.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/18/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddReviews.h"

@interface AddReViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *reviewContainer;
@property Country*currentCountry;
@property Country*currentState;
@property Country*currentParish;
@end
