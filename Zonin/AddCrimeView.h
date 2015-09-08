//
//  AddCrimeView.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/22/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App-Utilities.h"
#import "AFNetworking.h"
#import "Country.h"

@protocol ReportCrimeDelegate;
@interface AddCrimeView : UITableViewCell<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
//@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
//@property (weak, nonatomic) IBOutlet UIView *containerView;
//@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
//@property (weak, nonatomic) IBOutlet UITextField *txtState;
//@property (weak, nonatomic) IBOutlet UITextField *txtCounty;
//@property (weak, nonatomic) IBOutlet UITextField *txtCrimeTitle;
//@property (weak, nonatomic) IBOutlet UITextField *txtDate;
//@property (weak, nonatomic) IBOutlet UITextField *txtTime;
//@property (weak, nonatomic) IBOutlet UITextField *txtReporCrime;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *isAutonymus;
//@property (weak, nonatomic) IBOutlet UITextField *txtCrimeLocation;
@property (weak, nonatomic) IBOutlet UITextView *crimeDiscription;

//spiner container view
//@property (weak, nonatomic) IBOutlet UIView *spinnerCntainerView;
//@property (weak, nonatomic) IBOutlet UIPickerView *optionPicker;
//
////
////data
//@property (setter=setCountryList:)NSArray* CountryList;
//@property (setter=setStatList:)NSArray* StatList;
//@property (setter=setCountyListByState:)NSArray* CountyListByState;
//@property (setter=setCurrentCountry:)Country* currentCountry;
//@property (setter=setCurrentState:)Country*currentState;
//@property (setter=setCurrentCountyState:)Country*currentCountyState;
//@property(nonatomic,assign)id<ReportCrimeDelegate> delegate;
@end

//@protocol ReportCrimeDelegate <NSObject>
//@optional
////-(void)TouchOnAddMedi;
//-(void)TouchOnSubmitButtonWithValue:(NSDictionary*)Value;
////-(void)TouchOnRefreshButton;
//
//@end
