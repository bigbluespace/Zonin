//
//  SearchView.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/16/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "App-Utilities.h"
#import "Country.h"
@protocol searchViewDelegate;

@interface SearchView : UIView<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtCountryName;
@property (weak, nonatomic) IBOutlet UITextField *txtStateName;
@property (weak, nonatomic) IBOutlet UITextField *parishField;
@property (weak, nonatomic) IBOutlet UITextField *popularityField;
@property (weak, nonatomic) IBOutlet UITextField *keywordField;
@property (weak, nonatomic) IBOutlet UITextField *fromDateField;
@property (weak, nonatomic) IBOutlet UITextField *toDateField;


@property (weak, nonatomic) IBOutlet UIButton *fromDateButton;
@property (weak, nonatomic) IBOutlet UIButton *toDateButton;


@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *btnRefres;
@property (weak, nonatomic) IBOutlet UIButton *btnNewsHome;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *PickerContainer;
@property Country*currentCountry;
@property Country*currentState;
@property Country*currentParish;
@property Country*currentPopularity;

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//collections
//@property NSArray*countrys;
//@property NSArray* StatesUnderCountry;
@property(nonatomic,assign)id<searchViewDelegate> delegate;
-(void) setCountry:(NSArray *)countrys;

@end

@protocol searchViewDelegate <NSObject>
@optional
-(void)TouchOnNewsHomeButton;
-(void)TouchOnSearchButtonWithValue:(NSDictionary*)parameter;
-(void)TouchOnRefreshButton;
-(void)cancelButtonPressed;
-(void)textResignFirstResponder;
@end
