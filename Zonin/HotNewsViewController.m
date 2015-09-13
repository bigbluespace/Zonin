//
//  HotNewsViewController.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/15/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "HotNewsViewController.h"
#import "RESideMenu.h"
#import "MBProgressHUD.h"
#import "AdViewObject.h"
#import "Zonin.h"

@interface HotNewsViewController()
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchnewsBtn;
@property (weak, nonatomic) IBOutlet UIButton *viewFeedbackBtn;
@property (weak, nonatomic) IBOutlet UIButton *addFeedbackBtn;

@property (weak, nonatomic) IBOutlet UIView *addFeedbackView;
@property (weak, nonatomic) IBOutlet UITextView *feedDescription;

@end

@implementation HotNewsViewController
{
    NSArray*NewsNavigationButtonImage;
    UIWebView* newsBodyWebView;
    NSArray *allHotNews;
    SearchView*searchView;
    NSInteger index;
    AppDelegate*myAppdelegate;
    __weak IBOutlet UIView *adView;
    NSString *user_id;
}
-(void)viewDidLoad
{
    
    [super viewDidLoad];
    myAppdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    
    _searchnewsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _viewFeedbackBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _addFeedbackBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _addFeedbackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    user_id = [[Zonin readData:@"user_id"] valueForKey:@"user_id"];
    self.SearchHotNewsView.hidden=true;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    self.lblViewTitle.text=@"Hot News";
    allHotNews=self.hotnewsCollection;
    if (!allHotNews)
    {
        [_contentWebView loadHTMLString:@"An Error occured." baseURL:nil];
    }
    self.currentHotNews=self.currentHotNews;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


//------------------------
//load current hot news
-(void)setCurrentHotNews:(HotNews *)currentHotNews
{
    NSLog(@"change.....");
    _currentHotNews=currentHotNews;
    if (_currentHotNews)
    {
        NSLog(@"change.....1");
        self.lblNewsTitle.text=currentHotNews.news_title;
        self.lblNewsDate.text=currentHotNews.news_date;
        // self.NewsBodyText.text=news.news_desc;
        NSString* file_url=[News_fileURL_prefix stringByAppendingString:_currentHotNews.news_file];
        NSURL *url = [NSURL URLWithString:file_url];
        if ([_currentHotNews.news_file containsString:News_fileURL_prefix])
        {
            url = [NSURL URLWithString:self.currentHotNews.news_file];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *newsimage = [UIImage imageNamed:@"newsimage"];
        NSLog(@"news image url :%@",currentHotNews.news_file);
        [self.NewsImage setImageWithURLRequest:request
                              placeholderImage:newsimage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           self.NewsImage.image = image;
                                           [self.NewsImage setNeedsLayout];
                                           
                                       } failure:nil];
         NSString *html = [NSString stringWithFormat:@"<html><head></head><body style=\"color:#fff\">%@</body></html>",currentHotNews.news_desc];
        [_contentWebView loadHTMLString:html baseURL:nil];
    }
}

//-------------------------
//new navigation button function
-(void)NewsNavigationButtonClick:(UIButton*)sender
{
    index=[allHotNews indexOfObject:self.currentHotNews];
    
    NSLog(@"index is %ld",(long)index);
    if (sender.tag==101)
    {
        //
        //privious button
        if (index>0)
        {
            
            self.currentHotNews=[allHotNews objectAtIndex:index-1];
        }
        else
        {
            [self TostAlertMsg:@"No more hot news,go next."];
        }
    }
    if (sender.tag==102)
    {
        //
        //next button
        if (index<allHotNews.count-1)
        {
            NSLog(@"need to chnage");
            self.currentHotNews=[allHotNews objectAtIndex:index+1];
        }
        else
        {
           [self TostAlertMsg:@"No more hot news,go previous."];
        }
    }
    if (sender.tag==103)
    {
        //
        //serch button
      
                //[[UIApplication sharedApplication].keyWindow bringSubviewToFront:searchView];
        //load country
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       
        
        [Country getAllCountry:^(NSArray *list, NSError *error) {
            [self HideAllFromBackground:true];
            searchView=[[SearchView alloc]init];
            NSArray*nibs=[[NSBundle mainBundle] loadNibNamed:@"searchview"
                                                       owner:self options:nil];
            searchView=[nibs objectAtIndex:0];
            searchView.delegate=self;
            [searchView setFrame:self.NewsContainerView.bounds];
            [self.NewsContainerView addSubview:searchView];
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        }];
 
    }
    if (sender.tag==104)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSArray* feedbacklist=[self.currentHotNews Feedback];
        if (feedbacklist.count>0)
        {
        FeedbackVC* feedbackVC=[self.storyboard instantiateViewControllerWithIdentifier:@"feedbackvc"];
        feedbackVC.feedbacks=feedbacklist;
        [self.navigationController pushViewController:feedbackVC animated:YES];
        }
        else
        {
            [self TostAlertMsg:@"No feedback"];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    if (sender.tag==105)
    {
        
        if (myAppdelegate.logedUser.userID<=0)
        {
            [self TostAlertMsg:@"Login to add feedback"];
            return;
        }
        FeedBackView *feedview=[[FeedBackView alloc]init];
        NSArray*nibs=[[NSBundle mainBundle] loadNibNamed:@"feedback"
                                                   owner:self options:nil];
        feedview=[nibs objectAtIndex:0];
        feedview.delegate=self;
        [feedview setFrame:self.NewsImage.bounds];
        feedview.center=self.NewsImage.center;
        [self.NewsContainerView addSubview:feedview];
      
        
    }
}
#pragma mark - UIButtonEvent

- (IBAction)previousBtn:(id)sender {
    index=[allHotNews indexOfObject:self.currentHotNews];
    if (index>0){
        self.currentHotNews=[allHotNews objectAtIndex:index-1];
    } else {
        [self TostAlertMsg:@"No more hot news,go next."];
    }
}

- (IBAction)NextBtn:(id)sender {
    index=[allHotNews indexOfObject:self.currentHotNews];
    if (index<allHotNews.count-1){
        NSLog(@"need to chnage");
        self.currentHotNews=[allHotNews objectAtIndex:index+1];
    }else{
        [self TostAlertMsg:@"No more hot news,go previous."];
    }
}

- (IBAction)SearchNewsBtn:(id)sender {
    
}

- (IBAction)viewFeedbackBtn:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSArray* feedbacklist=[self.currentHotNews Feedback];
    if (feedbacklist.count>0){
        FeedbackVC* feedbackVC=[self.storyboard instantiateViewControllerWithIdentifier:@"feedbackvc"];
        feedbackVC.feedbacks=feedbacklist;
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
    else
    {
        [self TostAlertMsg:@"No feedback"];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)addFeedbackBtn:(id)sender {
    
    if ([user_id integerValue] == 0){
        [self TostAlertMsg:@"Login to add feedback"];
        return;
    }
    _addFeedbackView.hidden = NO;
    
    [self TouchOnAddfeedBack:_feedDescription.text];
}

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
//----------------------
//feedbackview dlegate
//----------------------
-(void)TouchOnAddfeedBack:(NSString *)Feedback
{
    NSLog(@"user id,%d and news id %d",myAppdelegate.logedUser.userID,self.currentHotNews.hot_news_id);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block NSString* alertmgs;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{@"user_id":[NSString stringWithFormat:@"%d", myAppdelegate.logedUser.userID],
                                 @"news_id":[NSString stringWithFormat:@"%d", self.currentHotNews.hot_news_id],
                                 key_news_feedback: Feedback,
                                 @"MACHINE_CODE": MACHINE_CODE
                                 };
    [manager POST:add_hot_news_feedback parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSDictionary*datadic=(NSDictionary*)responseObject;
         NSLog(@"json:%@",responseObject);
         if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
          
             [self TostAlertMsg:alertmgs];
         }
         else
         {
             alertmgs=[responseObject objectForKey:JSON_KEY_STATUS];
             if (!alertmgs)
             {
                 alertmgs=[responseObject objectForKey:JSON_KEY_ERROR];
             }
             [self TostAlertMsg:alertmgs];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         alertmgs=[error localizedDescription];
         [self TostAlertMsg:alertmgs];
     }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
//--------------------
//search view delegate
-(void)TouchOnNewsHomeButton
{
    [self HideAllFromBackground:NO];
}
-(void)TouchOnSearchButtonWithValue:(NSDictionary *)parameter
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:get_hot_news parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
        // UWebOparetion*webop=[[UWebOparetion alloc]init];
         if ([[responseObject objectForKey:JSON_KEY_MESSAGE] isEqual:SERVER_MESSAGE_SUCCESS])
         {
             NSLog(@"data found");
             NSMutableArray* newsArray=[[NSMutableArray alloc]init];
             NSDictionary* hotnewsDic=[responseObject objectForKey:JSON_KEY_STATUS];
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
                [newsArray addObject:temp];
                
                 NSLog(@"news title:%@",temp.news_title);
                 
             }
             NewsListVC* searchlist=[self.storyboard instantiateViewControllerWithIdentifier:@"newslistvc"];
             searchlist.hotNewsCollection=newsArray;
             [self.navigationController pushViewController:searchlist animated:YES];
         }
         else
         {
             [self TostAlertMsg:[responseObject objectForKey:JSON_KEY_ERROR]];
         }
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];

}
//---------------------
//spinner show and off
/*-(void)spinnerShow
{
    
    [newsBodyWebView addSubview:SpineerView ];
    SpineerView.backgroundColor=[UIColor clearColor];
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=SpineerView.center;
    [SpineerView addSubview:activityView];
    [activityView startAnimating];
    activityView.backgroundColor=[UIColor blueColor];
    [UIView animateWithDuration:0.2
                     animations:^{SpineerView.alpha = 1.0;}
                     completion:nil];
}
-(void)spinnerOff
{
    [UIView animateWithDuration:0.8
                     animations:^{SpineerView.alpha = 0.0;}
                     completion:^(BOOL finished){ [SpineerView removeFromSuperview]; }];
}*/
//-------------------
//hide all in background view for apearing serach view
-(void)HideAllFromBackground:(BOOL)action
{
    self.lblNewsDate.hidden=action;
    self.lblNewsTitle.hidden=action;
    for (UIView*a in [self.NewsContainerView subviews])
    {
        a.hidden=action;
        
    }
}
//
//textfields delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"editing text");
    return  NO;
}

#pragma mark - Add Feed Option
- (IBAction)feedCloseBtn:(id)sender {
    
}

- (IBAction)feedAddBtn:(id)sender {
    
}

@end
