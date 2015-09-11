//
//  SelectSettings.m
//  Zonin
//
//  Created by Rezaul Karim on 22/8/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "SelectSettings.h"
#import "RESideMenu.h"
#import "MBProgressHUD.h"
#import "AdViewObject.h"
#import "Zonin.h"



@interface SelectSettings (){
    NSArray *textFieldArray;
    NSMutableArray *languageList, *countryList, *stateList,*parishList, *pickerList, *pickerListTitle, *currentArray;
    
    CGFloat PORTRAIT_KEYBOARD_HEIGHT, animatedDistance, KEYBOARD_ANIMATION_DURATION;
    float origin;
    UIToolbar *toolBar;
    UILabel* toolbarTitle;
    NSInteger currentIndex, tempIndex, currentRank;
    UIView *tintView;
    
    UIPickerView* myPickerView;
    UITextField *currentField;
    NSString *user_id;
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UITextField *languageTxt;
@property (weak, nonatomic) IBOutlet UITextField *countryTxt;
@property (weak, nonatomic) IBOutlet UITextField *stateTxt;
@property (weak, nonatomic) IBOutlet UITextField *parishTxt;

@end

@implementation SelectSettings{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [[UITextField appearance] setTintColor:[UIColor redColor]];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    textFieldArray = @[_languageTxt, _countryTxt, _stateTxt,_parishTxt];
    languageList = [NSMutableArray array];
    countryList = [NSMutableArray array];
    stateList = [NSMutableArray array];
    parishList = [NSMutableArray array];
    currentArray = [NSMutableArray array];
    
    pickerList = [[NSMutableArray alloc] initWithArray:@[languageList, countryList, stateList,parishList]];
    pickerListTitle = [[NSMutableArray alloc] initWithArray:@[@"Language", @"Country",@"State",@"Parish"]];
    
    PORTRAIT_KEYBOARD_HEIGHT = 270;
    origin = self.view.frame.origin.y;
    KEYBOARD_ANIMATION_DURATION = 0.3;
    
    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 216)];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    
    [[UIPickerView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"picker_bg"]]];
    
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
    
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, self.view.frame.size.height-
                          myPickerView.frame.size.height-50, 320, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setItems:toolbarItems];
    [toolBar setTintColor:[UIColor whiteColor]];
    //[toolBar setBarTintColor:[UIColor colorWithRed:22.0/255.0 green:110.0/255.0 blue:209.0/255.0 alpha:1.0]];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    for (UITextField *text in textFieldArray) {
        [self setViewPicker:text];
    }
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    user_id = [[Zonin readData:@"user_id"] valueForKey:@"user_id"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Country getAllCountry:^(NSArray *list, NSError *error) {
        [self setCountry:list];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [self getLanguageList];
}

#pragma mark - Set Array To Picker & TextField 

-(void)getLanguageList{
    NSDictionary *dict = @{
                           @"MACHINE_CODE" : @"emran4axiz"
                           };
    NSString *url = @"http://zoninapp.com/admin/backend/api_zonin/get_language/emran4axiz";
    
    [Zonin commonPost:url parameters:dict block:^(NSDictionary *JSON, NSError *error) {
        if ([[JSON valueForKey:@"message"] isEqualToString:@"success"]) {
            languageList = [[NSMutableArray alloc] initWithArray:[JSON valueForKey:@"status"]];
            [pickerList replaceObjectAtIndex:0 withObject:languageList];
            if (languageList)
            {
                _currentLanguage=[languageList[0] valueForKey:@"language_name"];
                _languageTxt.text = _currentLanguage;
            }
        }
        
    }];
}

-(void)setCountry:(NSArray *)countrys
{
    countryList = [[NSMutableArray alloc] initWithArray:countrys];
    [pickerList replaceObjectAtIndex:1 withObject:countryList];
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
        _countryTxt.text=currentCountry.Name;
        
        [currentCountry getStates:^(NSArray *list, NSDictionary *error) {
            if (list != nil) {
                stateList = [[NSMutableArray alloc] initWithArray:list];
                [pickerList replaceObjectAtIndex:2 withObject:stateList];
                Country*temp=[stateList objectAtIndex:0];
                
                _stateTxt.text=temp.Name;
                _stateTxt.enabled = YES;
                
                self.currentState = temp;
                [self setCurrentState:temp];
 
            }else{
                _stateTxt.text=@"";
                _stateTxt.placeholder = @"No data found";
                _stateTxt.enabled = NO;
                self.currentState = nil;
            }
        }];
        
    }
}
-(void)setCurrentState:(Country *)currentState
{
    _currentState = currentState;
    if (currentState) {
        _stateTxt.text = currentState.Name;
        [self.currentState getAllCountyForSate:^(NSArray *list, NSDictionary *error) {
            if (list != nil) {
                parishList = [[NSMutableArray alloc] initWithArray:list];
                [pickerList replaceObjectAtIndex:3 withObject:parishList];
                Country*temp=[parishList objectAtIndex:0];
                _parishTxt.text=temp.Name;
                _parishTxt.enabled = YES;
                [self setCurrentParish:temp];
            }else{
                _parishTxt.text=@"";
                _parishTxt.placeholder = @"No data found";
                _parishTxt.enabled = NO;
            }
        }];
        //self.StatList=currentCountry.Stats;
    }
}

-(void)setCurrentParish:(Country *)currentParish
{
    _currentParish = currentParish;
    if (currentParish) {
        _parishTxt.text = currentParish.Name;
        
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    currentField = textField;
    NSUInteger index = [textFieldArray indexOfObject:textField];
    if (index != NSNotFound) {
        
        currentArray = [pickerList objectAtIndex:index];
        toolbarTitle.text = [pickerListTitle objectAtIndex:index];
        currentIndex = index;
        
        [myPickerView reloadAllComponents];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    [self animateView_Up:&textFieldRect];
    if(currentArray.count<=0)
        return;
    
    NSUInteger index = 0;
    
    [myPickerView selectRow:index inComponent:0 animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
// Catpure the picker view selection



- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateView_Down];
}

#pragma mark - animation functions
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

#pragma mark - Picker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"currentArray  %@", currentArray);
    return currentArray.count;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    NSAttributedString *attString;
    if ([currentArray isEqualToArray:languageList]) {
        title = [currentArray[row] valueForKey:@"language_name"] ;
        attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }else{
        title = ((Country*)currentArray[row]).Name ;
        attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    return attString;
    
}
//-----------------------
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (currentField==_languageTxt)
    {
        _currentLanguage=[languageList objectAtIndex:row];
        _languageTxt.text = [_currentLanguage valueForKey:@"language_name"];
    }
    else if (currentField==_countryTxt)
    {
        self.currentCountry=[countryList objectAtIndex:row];
        [self setCurrentCountry:self.currentCountry];
    }
    else if (currentField==_stateTxt)
    {
        self.currentState=[stateList objectAtIndex:row];
        [self setCurrentState: self.currentState];
    }
    else if (currentField==_parishTxt)
    {
        self.currentParish=[parishList objectAtIndex:row];
        [self setCurrentParish: self.currentParish];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark - Picker Toolbar button Event
-(void) next{
    
    tempIndex = currentIndex;
    if(currentIndex<textFieldArray.count-1){
        currentIndex++;
    }else{
        currentIndex = 0;
    }
    [[textFieldArray objectAtIndex:currentIndex] becomeFirstResponder];
    
}
-(void) previous{
    tempIndex = currentIndex;
    if(currentIndex>0){
        currentIndex--;
    }else{
        currentIndex = textFieldArray.count-1;
    }
    [[textFieldArray objectAtIndex:currentIndex] becomeFirstResponder];
}
-(void) done{
    if ([currentField isFirstResponder]) {
        [currentField resignFirstResponder];
    }
    
    [self textResignFirstResponder];
}

- (void)textResignFirstResponder{
    if (tintView != nil) {
        [tintView removeFromSuperview];
        tintView = nil;
    }
}

#pragma mark - SetView & toolbar

- (void)setViewPicker:(UITextField*)textField{
    textField.inputAccessoryView = toolBar;
    textField.inputView = myPickerView;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (IBAction)submitBtn:(UIButton *)sender {
    NSString *url = @"http://zoninapp.com/admin/backend/api_zonin/update_user_basic_info/emran4axiz";
    NSInteger countryId = self.currentCountry.country_id;
    
    NSDictionary *dict = @{
                           @"MACHINE_CODE" : @"emran4axiz",
                           @"user_id" : user_id,
                           @"country_id" : [NSString stringWithFormat:@"%ld",(long)countryId],
                           @"state_id" :[NSString stringWithFormat:@"%ld",(long)self.currentState.country_id],
                           @"county_id" :[NSString stringWithFormat:@"%ld",(long)self.currentParish.country_id]
                           };

    [Zonin commonPost:url parameters:dict block:^(NSDictionary *JSON, NSError *error) {
        NSLog(@"JSON %@", JSON);
    }];
}

- (IBAction)cancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
