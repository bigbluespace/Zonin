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

@implementation HotNewsViewController
{
    NSArray*NewsNavigationButtonImage;
    UIWebView* newsBodyWebView;
    NSArray *allHotNews;
    SearchView*searchView;
   // UIScrollView* scrollview;
    AppDelegate*myAppdelegate;
    __weak IBOutlet UIView *adView;
}
-(void)viewDidLoad
{
    
    [super viewDidLoad];
    //
    //scrollview=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    myAppdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NewsNavigationButtonImage=[[NSArray alloc]initWithObjects:@"previous", @"next",@"searchnews", @"viewfeedback", @"addfeedback",nil];
    self.SearchHotNewsView.hidden=true;
    //
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
   
    UIView* a =[[UIView alloc]initWithFrame:CGRectMake(10,180, self.NewsContainerView.bounds.size.width-20, self.NewsContainerView.bounds.size.height-225)];
    
    [self.NewsContainerView addSubview:a];
    a.backgroundColor=[UIColor clearColor];
    self.NewsBodyText=[[UITextView alloc]initWithFrame:a.bounds];
   
   // self.NewsBodyText.textColor = [UIColor whiteColor];
    newsBodyWebView=[[UIWebView alloc]initWithFrame:a.bounds];
   // [a addSubview:self.NewsBodyText];
    //setting up web view  for dsplaying body
    [a addSubview:newsBodyWebView];
    [newsBodyWebView setBackgroundColor:[UIColor clearColor]];
    [newsBodyWebView setOpaque:NO];

    self.NewsBodyText.backgroundColor=[UIColor clearColor];
    self.NewsBodyText.text=@"this is text";
    int buttonWeight=(self.NewsNavigationView.bounds.size.width-20)/4.7;
    int buttontag=101;
    for (int i=10; i<self.NewsNavigationView.bounds.size.width; i=i+buttonWeight)
    {
        UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(i-5, 10, buttonWeight-10, 20)];
        button.backgroundColor=[UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:[NewsNavigationButtonImage objectAtIndex:(buttontag-101)]] forState:UIControlStateNormal];
        button.tag=buttontag;
        buttontag++;
        [button addTarget:self action:@selector(NewsNavigationButtonClick:)forControlEvents:UIControlEventTouchUpInside];
        [self.NewsNavigationView addSubview:button];
        NSLog(@"button added");
    }
   
    
}
//view appearing
//-------------------------
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //SpineerView.backgroundColor=[UIColor lightTextColor];
    //[self spinnerShow];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
 
 
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
//--------------------------
- (void)viewWillDisappear:(BOOL)animated {
    
    
    
    [super viewWillDisappear:animated];
    
}
//--------------------------
-(void)viewDidAppear:(BOOL)animated
{
    self.lblViewTitle.text=@"Hot News";
    allHotNews=self.hotnewsCollection;
    if (!allHotNews)
    {
        [newsBodyWebView loadHTMLString:@"An Error occured." baseURL:nil];
    }
    self.currentHotNews=self.currentHotNews;
   // self.currentHotNews.news_file=[News_fileURL_prefix stringByAppendingString:_currentHotNews.news_file];
    //[self spinnerOff];
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
        [newsBodyWebView loadHTMLString:html baseURL:nil];
    }
}

//-------------------------
//new navigation button function
-(void)NewsNavigationButtonClick:(UIButton*)sender
{
    int index=[allHotNews indexOfObject:self.currentHotNews];
    
    NSLog(@"index is %d",index);
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
            //searchView.countrys=[Country getAllCountry];
            // searchView.StatesUnderCountry=[searchView.countrys obj]
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

@end
