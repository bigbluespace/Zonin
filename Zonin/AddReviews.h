//
//  AddReviews.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/18/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"
#import "Country.h"
#import "AFNetworking.h"
@interface AddReviews : UIView<UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *ContainerView;
@property (weak, nonatomic) IBOutlet UIView *RatingContainer;
//ui components
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtStateName;
@property (weak, nonatomic) IBOutlet UITextField *txtCountryParish;
@property (weak, nonatomic) IBOutlet UITextField *txtReviews;

@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;

@property (weak, nonatomic) IBOutlet UITextField *txtAgency;
@property (weak, nonatomic) IBOutlet UITextField *txtReviewFor;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficerName;
@property (weak, nonatomic) IBOutlet UITextView *txtReviewDetail;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchAnonymosity;
@property (weak, nonatomic) IBOutlet UIView *PickerViewCotainer;
@property (weak, nonatomic) IBOutlet UIPickerView *OptionPicker;

//
//data
@property (setter=setCountryList:)NSArray* CountryList;
@property (setter=setStatList:)NSArray* StatList;
@property (setter=setCountyListForSate:)NSArray* CountyListForSate;
@property (setter=setCurrentCountry:)Country* currentCountry;
@property (setter=setCurrentState:)Country*currentState;
@property (setter=setCurrentCounty:)Country*currentCounty;



@end
