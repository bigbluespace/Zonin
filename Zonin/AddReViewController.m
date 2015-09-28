//
//  AddReViewController.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/18/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "AddReViewController.h"
#import "RESideMenu.h"
#import "MBProgressHUD.h"
#import "AdViewObject.h"
#import "Zonin.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


@interface AddReViewController (){
    UIPickerView* myPickerView;
    UILabel* toolbarTitle;
    
    NSMutableArray *fieldList, *pickerArrayList, *pickerTitleList, *currentArray, *countryArray, *stateArray, *parishArray, *popularityArray, *rankButtonList;
    
    UITextView *detailTextView;
    
    UITextField *currentField, *countryField, *stateField, *parishField, *agencyField, *reviewField, *officerNameField;
    
    UIButton *rankButton1, *rankButton2, *rankButton3, *rankButton4, *rankButton5;
    
    NSInteger currentIndex, tempIndex, currentRank;
    
    CGFloat PORTRAIT_KEYBOARD_HEIGHT, animatedDistance, KEYBOARD_ANIMATION_DURATION;
    
    float origin;
    
    NSString *fromDate, *toDate, *anonymous;
    UIView *tintView;
    
    BOOL isTextView;
    UIToolbar *toolBar;
    UISwitch *anonymousSwitch;
}
@property (weak, nonatomic) IBOutlet UITableView *reviewTable;
@property (weak, nonatomic) IBOutlet UIView *adView;

@end

@implementation AddReViewController
{
    //AddReviews* review;
    //UIView*SpinnerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UITextField appearance] setTintColor:[UIColor redColor]];
    
    isTextView = NO;
    currentRank = 1;
    fieldList = [NSMutableArray array];
    pickerArrayList = [[NSMutableArray alloc] init];
    pickerTitleList = [[NSMutableArray alloc] init];
    rankButtonList = [[NSMutableArray alloc] init];
    
    PORTRAIT_KEYBOARD_HEIGHT = 270;
    origin = self.view.frame.origin.y;
    KEYBOARD_ANIMATION_DURATION = 0.3;

    countryArray = [[NSMutableArray alloc] init];
    stateArray = [[NSMutableArray alloc] init];
    parishArray = [[NSMutableArray alloc] init];
    
    [pickerArrayList addObjectsFromArray:@[countryArray, stateArray,parishArray,@[],@[],@[], @[]]];

    [pickerTitleList addObjectsFromArray:@[@"Country", @"State",@"Parish", @"Agency", @"Review", @"OfficerName", @"Detail"]];
    
    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 216)];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    
    [[UIPickerView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"picker_bg"]]];
   // _keywordField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    
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
    
    AdViewObject *add = [AdViewObject sharedManager];
    [_adView addSubview:add.adView];

    anonymous = @"yes";
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Country getAllCountry:^(NSArray *list, NSError *error) {
        [self setCountry:list];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_reviewTable reloadData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowTintedKeyboard:) name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark - Keyboard Notifications

- (void) handleShowTintedKeyboard:(NSNotification*)notification {
    if (tintView != nil || [detailTextView isFirstResponder]) {
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    
    // Get keyboard frames
    CGRect keyboardBeginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Get keyboard animation.
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Create animation.
    tintView = [[UIView alloc] initWithFrame:keyboardBeginFrame];
    tintView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"keyboard_bg"]];
    [self.view addSubview:tintView];
    
    // Begin animation.
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         tintView.frame = keyboardEndFrame;
                     }
                     completion:^(BOOL finished) {}];
}


- (void)textResignFirstResponder{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
    if (tintView != nil) {
        [tintView removeFromSuperview];
        tintView = nil;
    }
}

- (void)setLeftView:(UITextField*)textField{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}
- (void)pickerChanged:(id)sender
{
//    NSString *sender_date =[NSString stringWithFormat:@"%@", [sender date]];
//    NSArray *array = [sender_date componentsSeparatedByString:@" "];
//    
//    if (currentField == self.fromDateField) {
//        fromDate = array[0];
//        [_fromDateButton setTitle:array[0] forState:normal];
//    }else if (currentField == self.toDateField){
//        toDate = array[0];
//        [_toDateButton setTitle:array[0] forState:normal];
//    }
//    
//    NSLog(@"value: %@",array[0]);
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
    if ([currentField isFirstResponder]) {
        [currentField resignFirstResponder];
    }
    if ([detailTextView isFirstResponder]) {
        [detailTextView resignFirstResponder];
    }
    [self textResignFirstResponder];
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
        countryField.text=currentCountry.Name;
        
        [currentCountry getStates:^(NSArray *list, NSDictionary *error) {
            if (list != nil) {
                stateArray = [[NSMutableArray alloc] initWithArray:list];
                [pickerArrayList replaceObjectAtIndex:1 withObject:stateArray];
                Country*temp=[stateArray objectAtIndex:0];
                
                stateField.text=temp.Name;
                stateField.enabled = YES;
                
                self.currentState = temp;
                [self setCurrentState:temp];
                
                
            }else{
                stateField.text=@"";
                stateField.placeholder = @"No data found";
                stateField.enabled = NO;
                self.currentState = nil;
            }
            
            
            
        }];
        
    }
}

-(void)setCurrentState:(Country *)currentState
{
    _currentState = currentState;
    if (currentState) {
        parishField.text = currentState.Name;
        [self.currentState getAllCountyForSate:^(NSArray *list, NSDictionary *error) {
            if (list != nil) {
                parishArray = [[NSMutableArray alloc] initWithArray:list];
                [pickerArrayList replaceObjectAtIndex:2 withObject:parishArray];
                Country*temp=[parishArray objectAtIndex:0];
                parishField.text=temp.Name;
                parishField.enabled = YES;
                [self setCurrentParish:temp];
            }else{
                parishField.text=@"";
                parishField.placeholder = @"No data found";
                parishField.enabled = NO;
            }
        }];
        //self.StatList=currentCountry.Stats;
    }
}

-(void)setCurrentParish:(Country *)currentParish
{
    _currentParish = currentParish;
    if (currentParish) {
        parishField.text = currentParish.Name;
        
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"currentArray.count  %ld", (unsigned long)currentArray.count);
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
    if (currentField==countryField)
    {
        self.currentCountry=[countryArray objectAtIndex:row];
        [self setCurrentCountry:self.currentCountry];
    }
    else if (currentField==stateField)
    {
        self.currentState=[stateArray objectAtIndex:row];
        [self setCurrentState: self.currentState];
    }
    else if (currentField==parishField)
    {
        self.currentParish=[parishArray objectAtIndex:row];
        [self setCurrentParish: self.currentParish];
    }
//    else if (currentField==self.popularityField)
//    {
//        self.currentPopularity=[popularityArray objectAtIndex:row];
//        [self setCurrentPopularity: self.currentPopularity];
//    }
}

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
    
    /// NSPredicate *pre = [NSPredicate predicateWithFormat:@"(name contains[c] %@)", textField.text];
    //    NSArray *outArray = (NSArray*)[currentArray filteredArrayUsingPredicate:pre];
    //
    //    if(outArray.count>0)
    //        index = [currentArray indexOfObject:outArray[0]];
    
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


- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
//----------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//------------------------



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IPAD) {
        return 1010;
    }
    return 770;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    countryField = (UITextField*)[cell viewWithTag:1];
    countryField.delegate = self;
    countryField.inputAccessoryView = toolBar;
    countryField.inputView = myPickerView;
    [self setLeftView:countryField];
    fieldList[0] = countryField;
    
    stateField = (UITextField*)[cell viewWithTag:2];
    stateField.delegate = self;
    stateField.inputAccessoryView = toolBar;
    stateField.inputView = myPickerView;
    [self setLeftView:stateField];
    fieldList[1] = stateField;
    
    parishField = (UITextField*)[cell viewWithTag:3];
    parishField.delegate = self;
    parishField.inputAccessoryView = toolBar;
    parishField.inputView = myPickerView;
    [self setLeftView:parishField];
    fieldList[2] = parishField;
    
    agencyField = (UITextField*)[cell viewWithTag:4];
    agencyField.delegate = self;
    agencyField.inputAccessoryView = toolBar;
    //agencyField.inputView = myPickerView;
    [self setLeftView:agencyField];
    fieldList[3] = agencyField;
    agencyField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    reviewField = (UITextField*)[cell viewWithTag:5];
    reviewField.delegate = self;
    reviewField.inputAccessoryView = toolBar;
    //reviewField.inputView = myPickerView;
    [self setLeftView:reviewField];
    fieldList[4] = reviewField;
    reviewField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    officerNameField = (UITextField*)[cell viewWithTag:6];
    officerNameField.delegate = self;
    officerNameField.inputAccessoryView = toolBar;
    //officerNameField.inputView = myPickerView;
    [self setLeftView:officerNameField];
    fieldList[5] = officerNameField;
    officerNameField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    
    rankButton1 = (UIButton*)[cell viewWithTag:7];
    rankButtonList[0] = rankButton1;
    [rankButton1 addTarget:self action:@selector(rankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    rankButton2 = (UIButton*)[cell viewWithTag:8];
        rankButtonList[1] = rankButton2;
    [rankButton2 addTarget:self action:@selector(rankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    rankButton3 = (UIButton*)[cell viewWithTag:9];
        rankButtonList[2] = rankButton3;
    [rankButton3 addTarget:self action:@selector(rankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    rankButton4 = (UIButton*)[cell viewWithTag:10];
        rankButtonList[3] = rankButton4;
    [rankButton4 addTarget:self action:@selector(rankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    rankButton5 = (UIButton*)[cell viewWithTag:11];
        rankButtonList[4] = rankButton5;
    [rankButton5 addTarget:self action:@selector(rankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    detailTextView = (UITextView*)[cell viewWithTag:12];
    detailTextView.delegate = self;
    detailTextView.inputAccessoryView = toolBar;
    detailTextView.keyboardAppearance = UIKeyboardAppearanceDark;
    
    anonymousSwitch = (UISwitch*)[cell viewWithTag:13];
    [anonymousSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    UIButton * mediaButton = (UIButton*)[cell viewWithTag:14];
    [mediaButton addTarget:self action:@selector(openMedia:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * recordButton = (UIButton*)[cell viewWithTag:15];
    [recordButton addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton * submitButton = (UIButton*)[cell viewWithTag:16];
    
    [submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];


    
    
    return cell;
}

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        NSLog(@"Switch is ON");
        anonymous = @"yes";
    } else{
        NSLog(@"Switch is OFF");
        anonymous = @"no";
    }
}

- (IBAction)openMedia:(UIButton*)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Media"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Camera", @"Gallery", nil];
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }else if (buttonIndex==1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
        
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (IBAction)recordButtonClick:(UIButton*)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"This feature is c oming soon." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}

- (IBAction)submit:(UIButton*)sender {
//    , , ,review_zipcode,, , review_batch_add,review_badge_no,review_vehicle_no, review_precinct,,user_id,
//    file upload : review_feedback_files
    NSString *userId = [[Zonin readData:@"user_id"] valueForKey:@"user_id"];
    NSLog(@"user id  %@", userId);
    
    if (userId == nil || userId ==(id)[NSNull null]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please login first before submit incident." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:
                              nil];
        [alert show];
        return;
    }
    NSDictionary *param = @{
                            @"review_country_id": [NSString stringWithFormat:@"%d",self.currentCountry.country_id],
                            @"review_state_id": [NSString stringWithFormat:@"%d",self.currentState.country_id],
                            @"review_county_id" : [NSString stringWithFormat:@"%d",self.currentParish.country_id],
                            @"review_agency" : agencyField.text,
                            @"review_for" : reviewField.text,
                            @"review_rating" : [NSString stringWithFormat:@"%ld", (long)currentRank],
                            @"review_feedback_desc" : detailTextView.text
,
                            @"crime_user_id" : userId,
                            @"MACHINE_CODE" : @"emran4axiz"
                            };
    
    [Zonin commonPost:@"add_review" parameters:param block:^(NSDictionary *dataDic, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[dataDic valueForKey:@"message"] isEqualToString:@"success"] && error==nil) {
            
           
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"No data found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
           
        }
    }];

    
}

- (IBAction)rankButtonClick:(UIButton*)sender {
    
    currentRank = sender.tag - 6;
    for (int i = 0; i<rankButtonList.count; i++) {
        if (((UIButton*)rankButtonList[i]).tag <= sender.tag) {
            ((UIButton*)rankButtonList[i]).selected = YES;
        }else{
            ((UIButton*)rankButtonList[i]).selected = NO;
        }
    }
    NSLog(@"value %ld", (long)currentRank);
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    isTextView = YES;
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    [self animateView_Up:&textFieldRect];
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    isTextView= NO;
     [self animateView_Down];
}


@end
