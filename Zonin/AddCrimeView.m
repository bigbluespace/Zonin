//
//  AddCrimeView.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/22/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "AddCrimeView.h"

@implementation AddCrimeView
{
    UITextField* SelectedTextField;
    int pickerIndex;
    NSURL*chosenImage;
}
//-----------------------------------------
-(void)awakeFromNib
{
   
    
//    CGSize containerSize=self.containerView.bounds.size;
//    self.ScrollView.contentSize = containerSize;
//    CGRect scrollViewFrame = self.ScrollView.frame;
//    CGFloat scaleWidth = scrollViewFrame.size.width / self.ScrollView.contentSize.width;
//    CGFloat scaleHeight = scrollViewFrame.size.height / self.ScrollView.contentSize.height;
//    CGFloat minScale = MIN(scaleWidth, scaleHeight);
//   self.containerView.frame =CGRectMake(0, 0, self.bounds.size.width, 950);
//    self.ScrollView.minimumZoomScale = minScale;
//    self.ScrollView.maximumZoomScale = 1.0f;
//    self.ScrollView.zoomScale = 1.0f;
//    self.ScrollView.delegate=self;
//    self.txtCountry.delegate=self;
//    self.txtState.delegate=self;
//    self.txtCounty.delegate=self;
//    self.spinnerCntainerView.hidden=true;
    
}
//-----------------------------
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//
//scrolview delegate
//----------------------
//- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    // Return the view that we want to zoom
//    return self.containerView;
//}
//--------------------------------
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    // The scroll view has zoomed, so we need to re-center the contents
//    // [self centerScrollViewContents];
//}
//
//buttons function
//---------------------------
//- (IBAction)selectMediaTouch:(id)sender
//{
//    NSLog(@"select media");
//    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"SET A PICTURE" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take A Picture" otherButtonTitles:@"Select From Gallery", nil];
//    [sheet showInView:self];
//}
//------------------------------
//- (IBAction)submitReport:(id)sender
//{
//    __block NSString*alertmgs;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = @{@"MACHINE_CODE": MACHINE_CODE,
//                                 @"crime_country_id":[NSString stringWithFormat:@"%d", self.currentCountry.country_id],
//                                 @"crime_state_id": [NSString stringWithFormat:@"%d", self.currentState.country_id],
//                                 @"is_anonymous": [NSString stringWithFormat:@"%d", (int)self.isAutonymus.selectedSegmentIndex],
//                                 @"crime_location": self.txtCrimeLocation.text,
//                                 @"crime_date": self.txtDate.text,
//                                 @"crime_title": self.txtCrimeTitle.text,
//                                 @"crime_report": self.crimeDiscription.text,
//                                 @"crime_user_id": @"1",
//                                 };
//    //NSURL *filePath = [NSURL fileURLWithPath:chosenImage];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    [manager POST:add_crime parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileURL:chosenImage name:@"crime_files" error:nil];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject)
//    {
//        NSLog(@"return object: %@", responseObject);
//        if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
//        {
//        
//         alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
//         NSLog(@"message:%@",alertmgs);
//        }
//        else
//        {
//            alertmgs=[responseObject objectForKey:JSON_KEY_ERROR];
//        }
//        [self TostAlertMsg:alertmgs];
//        
//    }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error)
//    {
//        NSLog(@"Error: %@", error);
//        alertmgs=@"Error occured.try leter.";
//        [self TostAlertMsg:alertmgs];
//    }];
//    
//    NSLog(@"submit crime");
//}
//- (IBAction)btnDonetouch:(id)sender
//{
//    self.spinnerCntainerView.hidden=true;
//    if (SelectedTextField==self.txtCountry)
//    {
//        self.currentCountry=(Country*)[self.CountryList objectAtIndex:pickerIndex];
//    }
//    if (SelectedTextField==self.txtState)
//    {
//        self.currentState=(Country*)[self.StatList objectAtIndex:pickerIndex];
//    }
//    if (SelectedTextField==self.txtCounty)
//    {
//        self.currentCountyState=(Country*)[self.CountyListByState objectAtIndex:pickerIndex];
//    }
//    pickerIndex=0;
//}
//- (IBAction)btnCancelTouch:(id)sender
//{
//    self.spinnerCntainerView.hidden=true;
//    pickerIndex=0;
//
//}

//picker view delegae
//-----------------------------
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
////-------------------------------
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    if (SelectedTextField==self.txtCountry)
//    {
//        return self.CountryList.count;
//    }
//    if (SelectedTextField==self.txtState)
//    {
//        return self.StatList.count;
//    }
//    if (SelectedTextField==self.txtCounty)
//    {
//        return self.CountyListByState.count;
//    }
//    return 1;
//}
////------------------------------
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (SelectedTextField==self.txtCountry)
//    {
//        Country*temp=[self.CountryList objectAtIndex:row];
//        return temp.Name;
//    }
//    else if (SelectedTextField==self.txtState)
//    {
//        Country*temp=[self.StatList objectAtIndex:row];
//        return temp.Name;
//    }
//    else if (SelectedTextField==self.txtCounty)
//    {
//        Country*temp=[self.CountyListByState objectAtIndex:row];
//        return temp.Name;
//    }
//    else
//        return @"option";
//    
//}
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    pickerIndex=(int)row;
//}
////----------------------------
////
////textfield delegate function
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    SelectedTextField=textField;
//    self.optionPicker.delegate=self;
//    self.optionPicker.dataSource=self;
//    [self.optionPicker reloadComponent:0];
//    self.spinnerCntainerView.hidden=false;
//    return NO;
//}
////setter menthod
////
//-(void)setCountryList:(NSArray *)CountryList
//{
//    _CountryList=CountryList;
//    if (CountryList)
//    {
//        self.currentCountry=[_CountryList objectAtIndex:0];
//    }
//}
////-----------------------
//-(void)setCurrentCountry:(Country *)currentCountry
//{
//    _currentCountry=currentCountry;
//    if (currentCountry)
//    {
//        self.txtCountry.text=currentCountry.Name;
//        self.StatList=currentCountry.Stats;
//    }
//}
////------------------------
//-(void)setStatList:(NSArray *)StatList
//{
//    _StatList=StatList;
//    if (_StatList)
//    {
//        self.currentState=[_StatList objectAtIndex:0];
//    }
//}
////------------------------
//-(void)setCurrentState:(Country *)currentState
//{
//    _currentState=currentState;
//    if (currentState) {
//        self.txtState.text=currentState.Name;
//        self.CountyListByState=[self.currentState getAllCountyForSate];
//        //self.StatList=currentCountry.Stats;
//        
//    }
//    
//}
//-(void)setCountyListByState:(NSArray *)CountyListByState
//{
//    _CountyListByState=CountyListByState;
//    if (_CountyListByState)
//    {
//        self.currentCountyState=[_CountyListByState objectAtIndex:0];
//    }
//}
//-(void)setCurrentCountyState:(Country *)currentCountyState
//{
//    _currentCountyState=currentCountyState;
//    if (_currentCountyState) {
//        self.txtCounty.text=currentCountyState.Name;
//        //self.StatList=currentCountry.Stats;
//        
//    }
//}
////----------------------
////tost massage
//-(void)TostAlertMsg:(NSString*)alertmsg
//{
//    
//    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
//                                                    message:alertmsg
//                                                   delegate:nil
//                                          cancelButtonTitle:nil
//                                          otherButtonTitles:nil, nil];
//    [toast show];
//    
//    int duration = 1; // duration in seconds
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [toast dismissWithClickedButtonIndex:0 animated:YES];
//    });
//}
////---------------------
////---------------------
////action sheet delegate
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    if(buttonIndex==[actionSheet destructiveButtonIndex])
//    {
//        
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        //[picker setModalPresentationStyle:UIModalPresentationFormSheet];
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [[self.window rootViewController] presentViewController:picker animated:YES completion:nil];
//        }];
//        
//    }
//    else if (buttonIndex!=[actionSheet cancelButtonIndex])
//    {
//        
//        
//        // Don't forget to add UIImagePickerControllerDelegate in your .h
//        
//        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [picker setModalPresentationStyle:UIModalPresentationPageSheet];
//            [[self.window rootViewController] presentViewController:picker animated:YES completion:nil]; }];
//        
//    }
//}
////--------------------
////
////imape picker function
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//    chosenImage = info[UIImagePickerControllerReferenceURL];
//    // self.ProPicute.image = chosenImage;
//    NSLog(@"chosen image:%@",chosenImage);
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    
//}
@end
