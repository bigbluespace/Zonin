//
//  SearchView.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/16/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "SearchView.h"
#import "MBProgressHUD.h"


@implementation SearchView
{
    //UIDatePicker*DatePicker;
    UITextField* selectedfield;
    //UIPickerView* optionPicker;
    UIPickerView* myPickerView;
    UILabel* toolbarTitle;
    
    
    NSMutableArray* fieldList;
    NSMutableArray* pickerArrayList;
    NSMutableArray* pickerTitleList;
    
    NSMutableArray* currentArray;
    UITextField* currentField;
    NSInteger currentIndex;
    
    NSInteger tempIndex;
    
    CGFloat PORTRAIT_KEYBOARD_HEIGHT;
    
     float origin;
     CGFloat animatedDistance;
    CGFloat KEYBOARD_ANIMATION_DURATION ;
    
    NSMutableArray* countryArray;
    NSMutableArray* stateArray;
    NSMutableArray* parishArray;
    NSMutableArray* popularityArray;
    NSString *fromDate, *toDate;

    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    self.txtCountryName.delegate=self;
    self.txtStateName.delegate=self;
    self.parishField.delegate=self;
    self.popularityField.delegate=self;
    self.keywordField.delegate=self;
    self.fromDateField.delegate = self;
    self.toDateField.delegate = self;
    
    [[UITextField appearance] setTintColor:[UIColor redColor]];
    
    fieldList = [NSMutableArray array];
    pickerArrayList = [NSMutableArray array];
    pickerTitleList = [NSMutableArray array];
    
    PORTRAIT_KEYBOARD_HEIGHT = 270;
    origin = self.frame.origin.y;
    KEYBOARD_ANIMATION_DURATION = 0.3;
    
    [fieldList addObjectsFromArray:@[self.txtCountryName, self.txtStateName, self.parishField,self.popularityField,self.keywordField, self.fromDateField, self.toDateField]];
    
    //NSLog(@"countrys  %@", _countrys);
    countryArray = [[NSMutableArray alloc] init];
    stateArray = [[NSMutableArray alloc] init];
    parishArray = [[NSMutableArray alloc] init];
    //@property NSString *Name;
    //    @property int country_id;
    popularityArray = [[NSMutableArray alloc] init];
    
    Country *tempCountry = [[Country alloc] init];
    tempCountry.Name = @"Most popular";
    tempCountry.country_id = 1;
    [popularityArray addObject:tempCountry];
    
    tempCountry = [[Country alloc] init];
    tempCountry.Name = @"Moderate";
    tempCountry.country_id = 2;
    [popularityArray addObject:tempCountry];
    
    tempCountry = [[Country alloc] init];
    tempCountry.Name = @"Standard";
    tempCountry.country_id = 3;
    [popularityArray addObject:tempCountry];
    
    //WithArray:@[, @"Moderate", @"Standard"]];
    
    currentArray = countryArray;
    
    [pickerArrayList addObjectsFromArray:@[countryArray, stateArray,parishArray,popularityArray,@[],@[],@[]]];
    
    [pickerTitleList addObjectsFromArray:@[@"Country", @"State",@"Parish", @"Popularity", @"Keyword", @"From Date", @"To Date"]];
    
    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 216)];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    
    [[UIPickerView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"picker_bg"]]];
    _keywordField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    
    
    
    
    //[requestData setValue:@"0" forKey: @"data[Advert][any_price]"];
    
    UIButton *next_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    next_btn.frame = CGRectMake(0, 0, 30, 46);
    [next_btn setImage:[UIImage imageNamed:@"picker-next"] forState:UIControlStateNormal];
    [next_btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:next_btn];
    
    UIButton *prev_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    prev_btn.frame = CGRectMake(0, 0, 30, 46);
    [prev_btn setImage:[UIImage imageNamed:@"picker-prev"] forState:UIControlStateNormal];
    [prev_btn addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *pevButton = [[UIBarButtonItem alloc] initWithCustomView:prev_btn];
    
    toolbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 100, 21.0f)];
    [toolbarTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [toolbarTitle setBackgroundColor:[UIColor clearColor]];
    [toolbarTitle setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [toolbarTitle setText:@"Title"];
    [toolbarTitle setTextAlignment:NSTextAlignmentCenter];
    
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:toolbarTitle];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                   target:self action:@selector(done)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 20;
    
    NSArray *toolbarItems = [NSArray arrayWithObjects: pevButton, nextButton, flexibleItem, title, flexibleItem, doneButton, nil];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.frame.size.height-
                                     myPickerView.frame.size.height-50, 320, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setItems:toolbarItems];
    [toolBar setTintColor:[UIColor whiteColor]];
    //[toolBar setBarTintColor:[UIColor colorWithRed:22.0/255.0 green:110.0/255.0 blue:209.0/255.0 alpha:1.0]];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    
    self.txtCountryName.inputView = myPickerView;
    self.txtCountryName.inputAccessoryView = toolBar;
    [self setLeftView:self.txtCountryName];

    self.txtStateName.inputView = myPickerView;
    self.txtStateName.inputAccessoryView = toolBar;
        [self setLeftView:self.txtStateName];
    
    self.parishField.inputView = myPickerView;
    self.parishField.inputAccessoryView = toolBar;
        [self setLeftView:self.parishField];
    
    self.popularityField.inputView = myPickerView;
    self.popularityField.inputAccessoryView = toolBar;
        [self setLeftView:self.popularityField];
    
    self.keywordField.inputAccessoryView = toolBar;
        [self setLeftView:self.keywordField];
    
    
    CGRect pickerFrame = CGRectMake(0,250,0,0);
    
    UIDatePicker *myPicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [myPicker addTarget:self action:@selector(pickerChanged:)               forControlEvents:UIControlEventValueChanged];
    myPicker.datePickerMode = UIDatePickerModeDate;
    [myPicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    self.fromDateField.inputView = myPicker;
     self.fromDateField.inputAccessoryView = toolBar;
    
    self.toDateField.inputView = myPicker;
     self.toDateField.inputAccessoryView = toolBar;
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [Country getAllCountry:^(NSArray *list, NSError *error) {
        [self setCountry:list];
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}
- (void)setLeftView:(UITextField*)textField{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (IBAction)fromDateButtonClicked:(id)sender {
    [self.fromDateField becomeFirstResponder];
}


- (IBAction)toDateButtonClicked:(id)sender {
    [self.toDateField becomeFirstResponder];
}

- (void)pickerChanged:(id)sender
{
    NSString *sender_date =[NSString stringWithFormat:@"%@", [sender date]];
    NSArray *array = [sender_date componentsSeparatedByString:@" "];
    
    if (currentField == self.fromDateField) {
        fromDate = array[0];
        [_fromDateButton setTitle:array[0] forState:normal];
    }else if (currentField == self.toDateField){
        toDate = array[0];
        [_toDateButton setTitle:array[0] forState:normal];
    }
    
    NSLog(@"value: %@",array[0]);
}

-(void) next{
   
    tempIndex = currentIndex;
    if(currentIndex<fieldList.count-1){
        currentIndex++;
    }else{
        currentIndex = 0;
    }
    [[fieldList objectAtIndex:currentIndex] becomeFirstResponder];
    
}
-(void) previous{
    tempIndex = currentIndex;
    if(currentIndex>0){
        currentIndex--;
    }else{
        currentIndex = fieldList.count-1;
    }
    [[fieldList objectAtIndex:currentIndex] becomeFirstResponder];
}

-(void) done{
    [self.delegate textResignFirstResponder];
    [currentField resignFirstResponder];
}

- (IBAction)cancel:(id)sender {
    
    [self.delegate cancelButtonPressed];
    
}


//button functions
//--------------------------
- (IBAction)btnNewsHometouch:(id)sender {
    [self removeFromSuperview];
    [self.delegate TouchOnNewsHomeButton];
}
- (IBAction)btnRefresTouch:(id)sender {
    for (UIView*a in [self subviews])
    {
        if ([a isKindOfClass:[UITextField class]])
        {
            UITextField* txt=(UITextField*)a;
            txt.text=@"";
        }
    }
    //[self.delegate TouchOnRefreshButton];
}
- (IBAction)btnTouchSearch:(id)sender {
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
    
    if (_currentPopularity != nil) {
        [parameters setObject:[NSString stringWithFormat:@"%d",self.currentPopularity.country_id] forKey:@"hot_news_popularity"];
    }
    
    if (fromDate != nil) {
        [parameters setObject:fromDate forKey:@"from_date"];
    }
    
    if (toDate != nil) {
        [parameters setObject:fromDate forKey:@"to_date"];
    }
   
    [self.delegate TouchOnSearchButtonWithValue:parameters];
}

//---------------------------------
//- (IBAction)PickerCancelBotton:(id)sender {
//    [DatePicker removeFromSuperview];
//    [optionPicker removeFromSuperview];
//    self.pickerView.hidden=true;
//}
//- (IBAction)pickerDoneButton:(id)sender
//{
//    if (selectedfield==self.txtFromDate||selectedfield==self.txtTodate)
//    {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *currentTime = [dateFormatter stringFromDate:DatePicker.date];
//    selectedfield.text=currentTime;
//    }
//    [DatePicker removeFromSuperview];
//    [optionPicker removeFromSuperview];
//    self.pickerView.hidden=true;
//    if (selectedfield==self.txtCountryName)
//    {
//        //  Country*temp=[self.countrys objectAtIndex:0];
//        self.txtCountryName.text= self.currentCountry.Name;
//    }
//    if (selectedfield==self.txtStateName)
//    {
//        self.txtStateName.text=self.currentState.Name;
//    }
//
//    
//}
//
//textfield text changed
-(void)textChanged:(id)sender
{
    NSLog(@"text changed");
}

//-------------------------------
//
//text field delegate
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//     NSLog(@"editing text on view");
//    if (textField==self.txtKeyword)
//    {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDuration:0.5];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//         self.frame = CGRectMake(self.frame.origin.x, (self.frame.origin.y - 100.0), self.frame.size.width, self.frame.size.height);
//        [UIView commitAnimations];
//        return YES;
//    }
//    else if (textField==self.txtFromDate||textField==self.txtTodate)
//    {
//        selectedfield=textField;
//        self.pickerView.hidden=false;
//        DatePicker=[[UIDatePicker alloc]init];
//        DatePicker.maximumDate=[NSDate date];
//        DatePicker.datePickerMode=UIDatePickerModeDate;
//        [self.PickerContainer addSubview:DatePicker];
//       // DatePicker.center=self.pickerView.center;
//        return NO;
//    }
//  else
//  {
//       selectedfield=textField;
//      if (selectedfield==self.txtCountryName)
//      {
//        //  Country*temp=[self.countrys objectAtIndex:0];
//          self.txtCountryName.text= self.currentCountry.Name;
//      }
//      if (selectedfield==self.txtStateName)
//      {
//          self.txtStateName.text=self.currentState.Name;
//      }
//      [optionPicker removeFromSuperview];
//       self.pickerView.hidden=false;
//      optionPicker=[[UIPickerView alloc]init];
//      [self.PickerContainer addSubview:optionPicker];
//      optionPicker.delegate=self;
//      optionPicker.dataSource=self;
//    return  NO;
//  }
 //   return YES;
//}
//---------------

//--------------------------------------------
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    self.frame = CGRectMake(self.frame.origin.x, (self.frame.origin.y +100.0), self.frame.size.width, self.frame.size.height);
//    [UIView commitAnimations];
//}
//------------------------------------------

- (IBAction)textfieldValueChange:(id)sender {
    NSLog(@"value");
    
}
- (IBAction)Editingchange:(id)sender {
    NSLog(@"Edit..");
}
//
//----------------
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [DatePicker removeFromSuperview];
//    [optionPicker removeFromSuperview];
//     self.pickerView.hidden=true;
//    [self.txtKeyword resignFirstResponder];
}
//

//--------------------
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    if (selectedfield==self.txtCountryName)
//    {
//         return self.countrys.count;
//    }
//    if (selectedfield==self.txtStateName)
//    {
//        return self.StatesUnderCountry.count;
//    }
//    return 2;
//}
//-----------------------
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    
//    
//    if (selectedfield==self.txtCountryName)
//    {
//        Country*temp=[self.countrys objectAtIndex:row];
//        return temp.Name;
//    }
//    if (selectedfield==self.txtStateName)
//    {
//        Country*temp= [self.StatesUnderCountry objectAtIndex:row];
//        return temp.Name;
//    }
//    else
//        
//        
//        
//    return @"country name";
//}


//-----------------------------------
-(void)setCountry:(NSArray *)countrys
{
    countryArray = [[NSMutableArray alloc] initWithArray:countrys];
    [pickerArrayList replaceObjectAtIndex:0 withObject:countryArray];
    //countrys;
    if (countrys)
    {
        self.currentCountry=[countrys objectAtIndex:0];
       
    }
}
//----------------------
-(void)setCurrentCountry:(Country *)currentCountry
{
    _currentCountry=currentCountry;
    if (currentCountry)
    {
        self.txtCountryName.text=currentCountry.Name;
        
         [currentCountry getStates:^(NSArray *list, NSDictionary *error) {
             if (list != nil) {
                 stateArray = [[NSMutableArray alloc] initWithArray:list];
                 [pickerArrayList replaceObjectAtIndex:1 withObject:stateArray];
                 Country*temp=[stateArray objectAtIndex:0];
                 self.txtStateName.text=temp.Name;
                 self.txtStateName.enabled = YES;
             }else{
                 self.txtStateName.text=@"";
                 self.txtStateName.placeholder = @"No data found";
                 self.txtStateName.enabled = NO;
             }
             


        }];
        
    }
}

-(void)setCurrentState:(Country *)currentState
{
    _currentState = currentState;
    if (currentState) {
        self.txtStateName.text = currentState.Name;
       [self.currentState getAllCountyForSate:^(NSArray *list, NSDictionary *error) {
           if (list != nil) {
               parishArray = [[NSMutableArray alloc] initWithArray:list];
               [pickerArrayList replaceObjectAtIndex:2 withObject:parishArray];
               Country*temp=[parishArray objectAtIndex:0];
               _parishField.text=temp.Name;
               _parishField.enabled = YES;
           }else{
               _parishField.text=@"";
               _parishField.placeholder = @"No data found";
               _parishField.enabled = NO;
           }
        }];
        //self.StatList=currentCountry.Stats;
    }
}

-(void)setCurrentParish:(Country *)currentParish
{
    _currentParish = currentParish;
    if (currentParish) {
        self.parishField.text = currentParish.Name;
        
    }
}

-(void)setCurrentPopularity:(Country *)currentPopularity
{
    _currentPopularity = currentPopularity;
    if (currentPopularity) {
        self.popularityField.text = currentPopularity.Name;
        
    }
}


//----------------
//spinner view
//---------------------
//spinner show and off
//-(void)spinnerShow
//{
//    
//    [newsBodyWebView addSubview:SpineerView ];
//    SpineerView.backgroundColor=[UIColor clearColor];
//    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    
//    activityView.center=SpineerView.center;
//    [SpineerView addSubview:activityView];
//    [activityView startAnimating];
//    activityView.backgroundColor=[UIColor blueColor];
//    [UIView animateWithDuration:0.2
//                     animations:^{SpineerView.alpha = 1.0;}
//                     completion:nil];
//}
//-(void)spinnerOff
//{
//    [UIView animateWithDuration:0.8
//                     animations:^{SpineerView.alpha = 0.0;}
//                     completion:^(BOOL finished){ [SpineerView removeFromSuperview]; }];
//}
//-------------------
//--------------



// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   // NSLog(@"currentArray.count  %ld", currentArray.count);
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
    if (currentField==self.txtCountryName)
    {
        self.currentCountry=[countryArray objectAtIndex:row];
        [self setCurrentCountry:self.currentCountry];
    }
    else if (currentField==self.txtStateName)
    {
        self.currentState=[stateArray objectAtIndex:row];
        [self setCurrentState: self.currentState];
    }
    else if (currentField==self.parishField)
    {
        self.currentParish=[parishArray objectAtIndex:row];
        [self setCurrentParish: self.currentParish];
    }
    else if (currentField==self.popularityField)
    {
        self.currentPopularity=[popularityArray objectAtIndex:row];
        [self setCurrentPopularity: self.currentPopularity];
    }
}
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    //[self setPickerData:row];
//}

// The data to return for the row and component (column) that's being passed in
//- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return [currentArray[row] valueForKeyPath:@"name"];
//}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //NSLog(@"textFieldShouldBeginEditing");
    
    //  UITextField *tempTextField = tempTextField;
    
    currentField = textField;
    NSUInteger index = [fieldList indexOfObject:textField];
    if (index != NSNotFound) {
       
        currentArray = [pickerArrayList objectAtIndex:index];
        //NSLog(@"currenArray %@", currentArray);
       
        toolbarTitle.text = [pickerTitleList objectAtIndex:index];
        currentIndex = index;
        
        [myPickerView reloadAllComponents];
        
        
    }
    
    return YES;
}

#pragma mark -animation functions
- (void)animateView_Up: (CGRect*)rect{
    CGFloat fieldBottom =rect->origin.y+rect->size.height;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGRect viewFrame = self.frame;
    
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
    CGRect viewFrame = self.frame;
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
    
    [self setFrame:viewFrame];
    
    [UIView commitAnimations];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"textFieldDidBeginEditing");
    CGRect textFieldRect = [self.window convertRect:textField.bounds fromView:textField];
    [self animateView_Up:&textFieldRect];
    
    //Select Picker Row
    if(currentArray.count<=0)
        return;
    
    NSUInteger index = 0;
    
    
    [myPickerView selectRow:index inComponent:0 animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    return YES;
}
// Catpure the picker view selection



- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateView_Down];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
}
@end
