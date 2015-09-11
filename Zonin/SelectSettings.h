//
//  SelectSettings.h
//  Zonin
//
//  Created by Rezaul Karim on 22/8/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"
#import "AppDelegate.h"

@interface SelectSettings : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property Country*currentCountry;
@property Country*currentState;
@property Country*currentParish;
@property NSString *currentLanguage;
@end
