//
//  IncidentSearch.m
//  Zonin
//
//  Created by Admin on 28/09/15.
//  Copyright © 2015 UBITRIX. All rights reserved.
//

#import "IncidentSearch.h"
#import "RESideMenu.h"
#import "MBProgressHUD.h"
#import "AdViewObject.h"
#import "Zonin.h"
#import "Country.h"
#import "AddCrimeViewController.h"
#import "ReportOptonVC.h"

#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface IncidentSearch (){
    UIPickerView* myPickerView;
    
    NSMutableArray *fieldList, *pickerArrayList, *pickerTitleList, *currentArray, *countryArray, *stateArray, *parishArray;
    

    
    UITextField *currentField;
    NSInteger currentIndex, tempIndex;
    CGFloat PORTRAIT_KEYBOARD_HEIGHT, animatedDistance, KEYBOARD_ANIMATION_DURATION;
    
    float origin;
    
    NSString *fromDate, *toDate;
    
    CustomToolbar *toolBar;
    
}
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *provinceField;
@property (weak, nonatomic) IBOutlet UITextField *keywordField;
@property (weak, nonatomic) IBOutlet UIButton *fromDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *toDateBtn;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UITextField *fromDateField;
@property (weak, nonatomic) IBOutlet UITextField *toDateField;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;


@end

@implementation IncidentSearch

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isIncident) {
        [_reportBtn setTitle:@"REPORT INCIDENT" forState:normal];
    }else{
        [_reportBtn setTitle:@"REVIEW HOME" forState:normal];
    }

    AdViewObject *add = [AdViewObject sharedManager];
    [_adView addSubview:add.adView];
    
    toolBar = [[CustomToolbar alloc] initWithFrame: CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    toolBar.delegate = self;
    
    
    fieldList = [NSMutableArray array];
    pickerArrayList = [NSMutableArray array];
    pickerTitleList = [NSMutableArray array];
    
    PORTRAIT_KEYBOARD_HEIGHT = 270;
    origin = self.view.frame.origin.y;
    KEYBOARD_ANIMATION_DURATION = 0.3;
    
    [fieldList addObjectsFromArray:@[_countryField, _stateField, _provinceField,_keywordField,_fromDateField, _toDateField]];
    
    
    countryArray = [[NSMutableArray alloc] init];
    stateArray = [[NSMutableArray alloc] init];
    parishArray = [[NSMutableArray alloc] init];
    
    [pickerArrayList addObjectsFromArray:@[countryArray, stateArray,parishArray,@[],@[],@[]]];
    
    [pickerTitleList addObjectsFromArray:@[@"Country", @"State",@"Parish", @"Keyword", @"From Date", @"To Date"]];
    
    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 216)];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    
    [[UIPickerView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"picker_bg"]]];
    
    _keywordField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    _countryField.inputView = myPickerView;
    _countryField.inputAccessoryView = toolBar;
    [self setLeftView:_countryField];
    
    _stateField.inputView = myPickerView;
    _stateField.inputAccessoryView = toolBar;
    [self setLeftView:_stateField];
    
    _provinceField.inputView = myPickerView;
    _provinceField.inputAccessoryView = toolBar;
    [self setLeftView:_provinceField];
    
    
    _keywordField.inputAccessoryView = toolBar;
    [self setLeftView:_keywordField];
    
    
    CGRect pickerFrame = CGRectMake(0,250,0,0);
    
    UIDatePicker *myPicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [myPicker addTarget:self action:@selector(pickerChanged:)               forControlEvents:UIControlEventValueChanged];
    myPicker.datePickerMode = UIDatePickerModeDate;
    [myPicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    
    _fromDateField.inputView = myPicker;
    _fromDateField.inputAccessoryView = toolBar;
    
    _toDateField.inputView = myPicker;
    _toDateField.inputAccessoryView = toolBar;

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Country getAllCountry:^(NSArray *list, NSError *error) {
        [self setCountry:list];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

-(void)setCountry:(NSArray *)countrys
{
    countryArray = [[NSMutableArray alloc] initWithArray:countrys];
    [pickerArrayList replaceObjectAtIndex:0 withObject:countryArray];
    //countrys;
    if (countrys)
    {
        self.currentCountry=[countrys objectAtIndex:0];
        [self setCurrentCountry:self.currentCountry];
        
    }
}
//----------------------
-(void)setCurrentCountry:(Country *)currentCountry
{
    _currentCountry=currentCountry;
    if (currentCountry)
    {
        _countryField.text=currentCountry.Name;
        
        [currentCountry getStates:^(NSArray *list, NSDictionary *error) {
            if (list != nil) {
                stateArray = [[NSMutableArray alloc] initWithArray:list];
                [pickerArrayList replaceObjectAtIndex:1 withObject:stateArray];
                Country*temp=[stateArray objectAtIndex:0];
                
                _stateField.text=temp.Name;
                _stateField.enabled = YES;
                
                self.currentState = temp;
                [self setCurrentState:temp];
                
                
            }else{
                _stateField.text=@"";
                _stateField.placeholder = @"No data found";
                _stateField.enabled = NO;
                self.currentState = nil;
                
                _provinceField.text=@"";
                _provinceField.placeholder = @"No data found";
                _provinceField.enabled = NO;
                
                self.currentParish = nil;
            }
            
            
            
        }];
        
    }
}

-(void)setCurrentState:(Country *)currentState
{
    _currentState = currentState;
    if (currentState) {
        _stateField.text = currentState.Name;
        [self.currentState getAllCountyForSate:^(NSArray *list, NSDictionary *error) {
            if (list != nil) {
                parishArray = [[NSMutableArray alloc] initWithArray:list];
                [pickerArrayList replaceObjectAtIndex:2 withObject:parishArray];
                Country*temp=[parishArray objectAtIndex:0];
                _provinceField.text=temp.Name;
                _provinceField.enabled = YES;
                [self setCurrentParish:temp];
            }else{
                _provinceField.text=@"";
                _provinceField.placeholder = @"No data found";
                _provinceField.enabled = NO;
                
                self.currentParish = nil;
            }
        }];
        
    }
}

-(void)setCurrentParish:(Country *)currentParish
{
    _currentParish = currentParish;
    if (currentParish) {
        _provinceField.text = currentParish.Name;
        
    }
}


- (void)setLeftView:(UITextField*)textField{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}
- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (IBAction)searchBtn:(id)sender {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"MACHINE_CODE": MACHINE_CODE}];
    if (_currentCountry != nil) {
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentCountry.country_id] forKey:@"country_id"];
    }
    if (_currentState != nil) {
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentState.country_id] forKey:@"state_id"];
    }
    
    if (_currentCountry != nil) {
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentParish.country_id] forKey:@"county_id"];
    }
    
    if (fromDate != nil) {
        [parameters setObject:fromDate forKey:@"from_date"];
    }
    
    if (toDate != nil) {
        [parameters setObject:fromDate forKey:@"to_date"];
    }
    
    if (![_keywordField.text isEqualToString:@""]) {
        [parameters setObject:_keywordField.text forKey:@"keyword"];
    }
    
    [Zonin commonPost:_isIncident ? @"get_crime_as_state_country" : @"get_review_as_country_state_county" parameters:parameters block:^(NSDictionary *dataDic, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[dataDic valueForKey:@"message"] isEqualToString:@"success"] && error==nil) {
            ReportReviewVC*reviewlist=[self.storyboard instantiateViewControllerWithIdentifier:@"reportlistvc"];
            reviewlist.isCrimeReport = _isIncident;

            if (_isIncident) {
                reviewlist.tableItems = [dataDic valueForKey:@"status"];
                
            }else{
                NSMutableArray* crimes=[[NSMutableArray alloc]init];
                NSDictionary* crimedic=[dataDic objectForKey:JSON_KEY_STATUS];
                for (NSDictionary* crime in crimedic)
                {
                    OfficerReviews*temp=[[OfficerReviews alloc]init];
                    temp.review_county_id=[[crime objectForKey:@"review_county_id"]intValue];
                    temp.review_date=[crime objectForKey:@"review_date"];
                    temp.review_id=[[crime objectForKey:@"review_id"]intValue];
                    temp.review_text=[crime objectForKey:@"review_text"];
                    temp.review_for=[crime objectForKey:@"review_for"];
                    //
                    temp.review_rating=[[NSString stringWithFormat:@"%@",[crime objectForKey:@"review_rating"]]intValue];
                    temp.officer_name=[crime objectForKey:@"review_officer_name"];
                    temp.country_name=[crime objectForKey:@"country_name"];
                    temp.state_name=[crime objectForKey:@"state_name"];
                    temp.review_details=[crime objectForKey:@"review_details"];
                    temp.f_name=[crime objectForKey:@"f_name"];
                    temp.l_name=[crime objectForKey:@"l_name"];
                    temp.agency=[crime objectForKey:@"agency"];
                    //  temp.review_text=[crime objectForKey:@"review_text"];
                    
                    [crimes addObject:temp];
                }
                reviewlist.tableItems = crimes;

            }
            
            
            [self.navigationController pushViewController:reviewlist animated:YES];
            
            }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"No data found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
    }];
    
    
}
- (IBAction)cancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)refreshBtn:(id)sender {
    for (UIView*a in fieldList)
    {
        if ([a isKindOfClass:[UITextField class]])
        {
            UITextField* txt=(UITextField*)a;
            txt.text=@"";
        }
    }
}
- (IBAction)newsHome:(id)sender {
    if (_isIncident) {
        AddCrimeViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"addCrimeView"];
        [self.navigationController pushViewController:cv animated:YES];
    }else{
        
        ReportOptonVC *rc = [self.storyboard instantiateViewControllerWithIdentifier:@"reportOptonVC"];
        [self.navigationController pushViewController:rc animated:YES];
    }
    
}
- (IBAction)fromDateBtn:(id)sender {
    [_fromDateField becomeFirstResponder];
}
- (IBAction)toDateBtn:(id)sender {
    [_toDateField becomeFirstResponder];
  
}

- (void)pickerChanged:(id)sender
{
    NSString *sender_date =[NSString stringWithFormat:@"%@", [sender date]];
    NSArray *array = [sender_date componentsSeparatedByString:@" "];
    
    if (currentField == self.fromDateField) {
        fromDate = array[0];
        [_fromDateBtn setTitle:array[0] forState:normal];
    }else if (currentField == self.toDateField){
        toDate = array[0];
        [_toDateBtn setTitle:array[0] forState:normal];
    }
    
    NSLog(@"value: %@",array[0]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toolbarNext{
    tempIndex = currentIndex;
    if(currentIndex<fieldList.count-1){
        currentIndex++;
    }else{
        currentIndex = 0;
    }
    [[fieldList objectAtIndex:currentIndex] becomeFirstResponder];
}

-(void)toolbarPrevious{
    tempIndex = currentIndex;
    if(currentIndex>0){
        currentIndex--;
    }else{
        currentIndex = fieldList.count-1;
    }
    [[fieldList objectAtIndex:currentIndex] becomeFirstResponder];
}
-(void)toolbarDone{
    
    [currentField resignFirstResponder];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //NSLog(@"currentArray.count  %ld", currentArray.count);
    return currentArray.count;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = ((Country*)currentArray[row]).Name ;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}
//-----------------------
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (currentField==_countryField)
    {
        self.currentCountry=[countryArray objectAtIndex:row];
        [self setCurrentCountry:self.currentCountry];
    }
    else if (currentField==_stateField)
    {
        self.currentState=[stateArray objectAtIndex:row];
        [self setCurrentState: self.currentState];
    }
    else if (currentField==_provinceField)
    {
        self.currentParish=[parishArray objectAtIndex:row];
        [self setCurrentParish: self.currentParish];
    }
   
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    currentField = textField;
    NSUInteger index = [fieldList indexOfObject:textField];
    if (index != NSNotFound) {
        
        currentArray = [pickerArrayList objectAtIndex:index];
        
       [toolBar setBarTitle:[pickerTitleList objectAtIndex:index]];
        currentIndex = index;
        
        [myPickerView reloadAllComponents];
        
        
    }
    
    return YES;
}



#pragma mark -animation functions
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
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"textFieldDidBeginEditing");
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    [self animateView_Up:&textFieldRect];
    
    //Select Picker Row
    if(currentArray.count<=0)
        return;
    
    NSUInteger index = 0;
    [myPickerView selectRow:index inComponent:0 animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateView_Down];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
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
