//
//  AddReviews.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/18/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "AddReviews.h"

@implementation AddReviews
{
    ASStarRatingView* rating;
    NSArray* ReviewsForList;
    UITextField* selectedTextfield;
    int selectedIndex;
    NSArray* reviewFields;
    NSMutableArray*reviewsFieldsValue;
    UIView*SpinnerView;
    NSURL *chosenImage;
}
-(void)awakeFromNib
{
    CGSize containerSize=self.ContainerView.bounds.size;
    self.scrollView.contentSize = containerSize;
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.ContainerView.frame =CGRectMake(0, 0, self.bounds.size.width, 950);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = 1.0f;
    self.scrollView.delegate=self;
    //picker view option
    self.PickerViewCotainer.hidden=true;
    
    //textfield option
    self.txtCountry.delegate=self;
    self.txtStateName.delegate=self;
    self.txtReviewFor.delegate=self;
    self.txtCountryParish.delegate=self;
    //
    //
    SpinnerView=[[UIView alloc]initWithFrame:self.superview.bounds];
    SpinnerView.backgroundColor=[UIColor whiteColor];
    //[self centerScrollViewContents];
    //
    //ratiing view
    rating=[[ASStarRatingView alloc]initWithFrame:self.RatingContainer.bounds];
    [self.RatingContainer addSubview:rating];
    self.RatingContainer.backgroundColor=[UIColor clearColor];
    
    //-------------------------
    //data
    ReviewsForList=[[NSArray alloc]initWithObjects:@"officer",@"Badge",@"Vehicle",@"Precinct", nil];
    //
    //set reviewspost value data
    reviewFields=[[NSArray alloc]initWithObjects:@"MACHINE_CODE",@"review_country_id",@"review_state_id",@"review_county_id", @"review_zipcode",@"review_for",@"review_text",@"review_rating",@"user_id",@"review_feedback_desc",nil];
    
}
//----------------
//view controler for view
- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    }
    else if (![nextResponder isKindOfClass:[UIViewController class]])
    {
        return [nextResponder traverseResponderChainForUIViewController];
    } else
    {
        return nil;
    }
}
//
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.ContainerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width)
    {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else
    {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.ContainerView.frame = contentsFrame;
}
//button function
//-----------------------
- (IBAction)selectmediatouch:(id)sender
{
    NSLog(@"select media");
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"SET A PICTURE" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take A Picture" otherButtonTitles:@"Select From Gallery", nil];
    [sheet showInView:self];
}
//----------------------------
- (IBAction)submittouch:(id)sender
{
    NSLog(@"submit");
    SpinnerView=[[UIView alloc]initWithFrame:self.superview.bounds];
    SpinnerView.backgroundColor=[UIColor whiteColor];
    reviewsFieldsValue=[[NSMutableArray alloc]initWithObjects:MACHINE_CODE,[NSString stringWithFormat:@"%d",self.currentCountry.country_id],[NSString stringWithFormat:@"%d",self.currentState.country_id],[NSString stringWithFormat:@"%d",self.currentCounty.country_id],self.txtZipCode.text,self.txtReviewFor.text,self.txtReviews.text,[NSString stringWithFormat:@"%f",rating.rating],@"10",self.txtReviewDetail.text, nil];
   // UWebOparetion * webop=[[UWebOparetion alloc]init];
    [self spinnerShow];
   
    NSDictionary *parameters=[[NSDictionary alloc]initWithObjects:reviewsFieldsValue forKeys:reviewFields];
    
   // NSData* data=[webop sendDataByPostWithFieldName:reviewFields andValue:reviewsFieldsValue forWebPage:add_review];
   // NSDictionary* Datadic=[webop parseJESONObjectFromData:data];
    __block NSString*alertmgs;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    NSURL *filePath = [NSURL fileURLWithPath:@"common.png"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSLog(@"image set:%@",chosenImage);
    [manager POST:add_review parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:chosenImage name:@"review_feedback_files" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"return object: %@", responseObject);
         if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
         {
             
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             NSLog(@"message:%@",alertmgs);
         }
         else
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_ERROR];
         }
         [self TostAlertMsg:alertmgs];
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         alertmgs=@"Error occured.try leter.";
         [self TostAlertMsg:alertmgs];
     }];
    
    NSLog(@"submit crime");
    [self spinnerOff];
}
//picker button function
- (IBAction)btnDoneTouch:(id)sender {
    self.PickerViewCotainer.hidden=true;
    if (selectedTextfield==self.txtCountry)
    {
        self.currentCountry=[self.CountryList objectAtIndex:selectedIndex];
        selectedIndex=0;
        return;
    }
    else if (selectedTextfield==self.txtStateName)
    {
        self.currentState=[self.StatList objectAtIndex:selectedIndex];
        selectedIndex=0;
        return;
    }
    else if (selectedTextfield==self.txtCountryParish)
    {
        //self.txtCountryParish.text=[self.CountyListForSate objectAtIndex:selectedIndex]
        self.currentCounty=[self.CountyListForSate objectAtIndex:selectedIndex];
        self.txtCountryParish.text=self.currentCounty.Name;
        selectedIndex=0;
        return;
    }
   else if (selectedTextfield==self.txtReviewFor)
    {
        self.txtReviewFor.text=[ReviewsForList objectAtIndex:selectedIndex];
        selectedIndex=0;
        return;
    }
    //
    //reset selected index
    
}
- (IBAction)btnCancelTouch:(id)sender {
    selectedIndex=0;
    self.PickerViewCotainer.hidden=true;
    NSLog(@"cancel");
}

//--------------------
//setters method
-(void)setCountryList:(NSArray *)CountryList
{
    _CountryList=CountryList;
    if (CountryList)
    {
        self.currentCountry=[_CountryList objectAtIndex:0];
    }
}
//-----------------------
-(void)setCurrentCountry:(Country *)currentCountry
{
    _currentCountry=currentCountry;
    if (currentCountry)
        {
        self.txtCountry.text=currentCountry.Name;
        self.StatList=currentCountry.Stats;
        }
}
//------------------------
-(void)setStatList:(NSArray *)StatList
{
    _StatList=StatList;
    if (_StatList)
    {
        self.currentState=[_StatList objectAtIndex:0];
    }
}
-(void)setCurrentState:(Country *)currentState
{
    _currentState=currentState;
    if (currentState) {
        self.txtStateName.text=currentState.Name;
        //self.StatList=currentCountry.Stats;
        [self.currentState getAllCountyForSate:^(NSArray *list, NSDictionary *error) {
            self.CountyListForSate= list;
        }];
        
    }
    
}
-(void)setCountyListForSate:(NSArray *)CountyListForSate
{
    _CountyListForSate=CountyListForSate;
    if (_CountyListForSate) {
        self.currentCounty=[_CountyListForSate objectAtIndex:0];
        
    }
    
}-(void)setCurrentCounty:(Country *)currentCounty
{
    NSLog(@"current county setter");
    _currentCountry=currentCounty;
    if (_currentCountry)
    {
        self.txtCountryParish.text=self.currentCounty.Name;
    }
}
//----------------------
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.ContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
   // [self centerScrollViewContents];
}

//------------------
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-------------------------------
///textfield delegate function
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    selectedTextfield=textField;
    self.OptionPicker.delegate=self;
    self.OptionPicker.dataSource=self;
    if (textField==self.txtCountry)
    {
        self.PickerViewCotainer.hidden=false;
        [self.OptionPicker reloadComponent:0];
        return NO;
    }
    if (textField==self.txtStateName)
    {
        self.PickerViewCotainer.hidden=false;
        [self.OptionPicker reloadComponent:0];
        return NO;
    }
    if (textField==self.txtReviewFor)
    {
        self.PickerViewCotainer.hidden=false;
        [self.OptionPicker reloadComponent:0];
        return NO;
    }
    if (textField==self.txtCountryParish)
    {
        self.PickerViewCotainer.hidden=false;
        [self.OptionPicker reloadComponent:0];
        return NO;
    }

    
    return YES;
}
//
//pickerview delegate and datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//--------------------
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (selectedTextfield==self.txtCountry)
    {
        return self.CountryList.count;
    }
    if (selectedTextfield==self.txtStateName)
    {
        return self.StatList.count;
    }
    if (selectedTextfield==self.txtReviewFor)
    {
        return ReviewsForList.count;
    }
    if (selectedTextfield==self.txtCountryParish)
    {
        return self.CountyListForSate.count;
    }
    return 2;
}
//-----------------------
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (selectedTextfield==self.txtCountry)
    {
        Country*temp=[self.CountryList objectAtIndex:row];
        return temp.Name;
        
    }
    if (selectedTextfield==self.txtStateName)
    {
        Country*temp=[self.StatList objectAtIndex:row];
        return temp.Name;
        
    }
    if (selectedTextfield==self.txtCountryParish)
    {
        Country*temp=[self.CountyListForSate objectAtIndex:row];
        return temp.Name;
        
    }
    if (selectedTextfield==self.txtReviewFor)
    {
        return [ReviewsForList objectAtIndex:row];
    }
    
    return @"my country";
}
//-----------------------
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex=row;
    //selectedfield.text=[pickerView ]
}
//------------------------
-(void)spinnerShow
{
    
    [self.superview addSubview:SpinnerView ];
    SpinnerView.backgroundColor=[UIColor clearColor];
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=SpinnerView.center;
    [SpinnerView addSubview:activityView];
    [activityView startAnimating];
    activityView.backgroundColor=[UIColor blueColor];
    [UIView animateWithDuration:0.2
                     animations:^{SpinnerView.alpha = 1.0;}
                     completion:nil];
}
-(void)spinnerOff
{
    [UIView animateWithDuration:0.8
                     animations:^{SpinnerView.alpha = 0.0;}
                     completion:^(BOOL finished){ [SpinnerView removeFromSuperview]; }];
}
//----------------------
//tost massage
-(void)TostAlertMsg:(NSString*)alertmsg
{
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertmsg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}
//---------------------
//action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if(buttonIndex==[actionSheet destructiveButtonIndex])
    {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //[picker setModalPresentationStyle:UIModalPresentationFormSheet];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[self.window rootViewController] presentViewController:picker animated:YES completion:nil];
        }];
        
    }
    else if (buttonIndex!=[actionSheet cancelButtonIndex])
    {
        
        
        // Don't forget to add UIImagePickerControllerDelegate in your .h
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [picker setModalPresentationStyle:UIModalPresentationPageSheet];
            [[self.window rootViewController] presentViewController:picker animated:YES completion:nil]; }];
        
    }
}
//--------------------
//
//imape picker function
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
   chosenImage = info[UIImagePickerControllerReferenceURL];
    // self.ProPicute.image = chosenImage;
    NSLog(@"chosen image:%@",chosenImage);
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
