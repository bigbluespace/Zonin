//
//  SearchVC.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/28/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "SearchVC.h"
#import "RESideMenu.h"
#import "MBProgressHUD.h"
#import "Zonin.h"
#import "AdViewObject.h"
#import "IncidentSearch.h"

@interface SearchVC ()

@end

@implementation SearchVC
{
    SearchView* searchView;
    UIView*SpinnerView;
    UIView *tintView;
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SpinnerView=[[UIView alloc]initWithFrame:self.containerView.bounds];
    self.navigationController.navigationBarHidden = YES;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowTintedKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}
#pragma mark - Keyboard Notifications

- (void) handleShowTintedKeyboard:(NSNotification*)notification {
    if (tintView != nil) {
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
    //tintView.tag = kKeyboardTintViewTag;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
-(void) cancelButtonPressed{
    [searchView removeFromSuperview];
    [self visibilityHidden:NO inview:self.containerView];
}
//-------------
//search option buton click
- (IBAction)hotNewsClick:(id)sender
{
    [self visibilityHidden:YES inview:self.containerView];
    searchView=[[SearchView alloc]init];
    NSArray*nibs=[[NSBundle mainBundle] loadNibNamed:@"searchview"
                                               owner:self options:nil];
    searchView=[nibs objectAtIndex:0];
    searchView.delegate=self;
    [searchView setFrame:self.containerView.bounds];
    [self.containerView addSubview:searchView];
}

//------------
//---------------
//showig tost
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
//search view delegate
-(void)TouchOnNewsHomeButton
{
    searchView.hidden=true;
    [self visibilityHidden:NO inview:self.containerView];
}


-(void)getHotNewsData:(NSDictionary*)param{
    NSMutableArray* hotnews=[[NSMutableArray alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Zonin commonPost:@"get_hot_news" parameters:param block:^(NSDictionary *dataDic, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[dataDic valueForKey:@"message"] isEqualToString:@"success"] && error==nil) {
            
            if ([[dataDic objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
            {
                NSLog(@"data found");
                NSDictionary* hotnewsDic=[dataDic objectForKey:JSON_KEY_STATUS];
                for (NSDictionary* news in hotnewsDic)
                {
                    HotNews * temp=[[HotNews alloc]init];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_title=[news objectForKey:key_news_title];
                    temp.news_desc=[news objectForKey:key_news_desc];
                    temp.news_file=[news objectForKey:key_news_file];
                    temp.country_id=[[news objectForKey:key_country_id]integerValue];
                    temp.hot_news_id=[[news objectForKey:key_hot_news_id]integerValue];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_date=[news objectForKey:key_news_date];
                    temp.news_date=[news objectForKey:key_news_date];
                    [hotnews addObject:temp];
                    
                }
//                self.hotNewsCollection = hotnews;
//                [self.TableNewsList reloadData];
                NewsListVC* searchlist=[self.storyboard instantiateViewControllerWithIdentifier:@"newslistvc"];
                searchlist.hotNewsCollection=hotnews;
                [self.navigationController pushViewController:searchlist animated:YES];
            }
            else
            {
                //                HotNews * temp=[[HotNews alloc]init];
                //                temp.news_desc=[dataDic objectForKey:JSON_KEY_ERROR];
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error   valueForKey:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
//                [self.TableNewsList reloadData];
            }
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"No data found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
//            [self.TableNewsList reloadData];
        }
    }];
}
-(void)TouchOnSearchButtonWithValue:(NSDictionary *)parameter
{
    [self getHotNewsData:parameter];
    [searchView removeFromSuperview];
    [self visibilityHidden:NO inview:self.containerView];
}
//---------------------
//visibility hide or show
-(void)visibilityHidden:(BOOL)action inview:(UIView*)mView
{
    for (UIView*a in [mView subviews])
    {
        if ([a isKindOfClass:[UIButton class]]||[a isKindOfClass:[UITextField class]]||[a isKindOfClass:[UILabel class]])
        {
            a.hidden=action;
        }
    }
}
- (IBAction)searchIncident:(id)sender {
    //
    IncidentSearch *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"incidentSearch"];
    vc.isIncident = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)searchReview:(id)sender {
    IncidentSearch *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"incidentSearch"];
    vc.isIncident = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)headerClicked:(id)sender {
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"home"]]
                                                 animated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//---------------------
//spinner show and off
-(void)spinnerShow
{
    
    [self.containerView addSubview:SpinnerView ];
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
//-------------------
@end
