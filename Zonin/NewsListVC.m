//
//  NewsListVC.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/21/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "NewsListVC.h"
#import "Zonin.h"
#import "MBProgressHUD.h"
#import "RESideMenu.h"
#import "AdViewObject.h"
#import "UIImageView+AFNetworking.h"

#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface NewsListVC (){
    SearchView* searchView;
    UIView *tintView;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBtnConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHeightConstraint;

@end

@implementation NewsListVC
{
    __weak IBOutlet UIView *adView;
}
static NSInteger kKeyboardTintViewTag = 1234;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setTitle:@"New List"];
    self.TableNewsList.backgroundColor = [UIColor clearColor];
    self.TableNewsList.opaque = NO;
    self.TableNewsList.backgroundView = nil;
    
     self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
    
    NSDictionary *postData = @{
                               @"MACHINE_CODE" : @"emran4axiz"
    
                               };
    
    [self getHotNewsData:postData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowTintedKeyboard:) name:UIKeyboardWillShowNotification object:nil];
   
    
    self.view.backgroundColor = [UIColor clearColor];
    if (IPAD) {
        _adViewConstraint.constant = 150;
        _searchBtnConstraint.constant = 72;
        _headerHeightConstraint.constant = 160;
        _menuHeightConstraint.constant = 48;
    }
    
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
                self.hotNewsCollection = hotnews;
                [self.TableNewsList reloadData];
            }
            else
            {
                //                HotNews * temp=[[HotNews alloc]init];
                //                temp.news_desc=[dataDic objectForKey:JSON_KEY_ERROR];
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error   valueForKey:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [self.TableNewsList reloadData];
            }
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"No data found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.TableNewsList reloadData];
        }
    }];
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
    tintView.tag = kKeyboardTintViewTag;
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

- (IBAction)searchNews:(id)sender {
        //[self spinnerShow];
    
    [self visibilityHidden:YES inview:self.containerView];
    searchView=[[SearchView alloc]init];
    NSArray*nibs=[[NSBundle mainBundle] loadNibNamed:@"searchview"
                                               owner:self options:nil];
    searchView=[nibs objectAtIndex:0];
    searchView.delegate=self;
    [searchView setFrame:self.containerView.bounds];
    [self.containerView addSubview:searchView];
    
    // searchView.StatesUnderCountry=[searchView.countrys obj]
  //  [self spinnerOff];
    }
-(void)visibilityHidden:(BOOL)action inview:(UIView*)mView
{
    for (UIView*a in [mView subviews])
    {
        if ([a isKindOfClass:[UIButton class]]||[a isKindOfClass:[UITextField class]]||[a isKindOfClass:[UILabel class]]  || [a isKindOfClass:[UITableView class]])
        {
            a.hidden=action;
        }
    }
}

-(void) TouchOnSearchButtonWithValue:(NSDictionary *)parameter{
    
    self.hotNewsCollection = @[];
    
    [self getHotNewsData:parameter];
    
    [searchView removeFromSuperview];
    [self visibilityHidden:NO inview:self.containerView];
}



-(void) cancelButtonPressed{
    [searchView removeFromSuperview];
    [self visibilityHidden:NO inview:self.containerView];
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}


-(void)viewDidAppear:(BOOL)animated
{
    self.TableNewsList.dataSource=self;
    self.TableNewsList.delegate=self;
    [self.TableNewsList reloadData];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"hotnews"]) {
         HotNewsViewController *destViewController = segue.destinationViewController;
         destViewController.hotnewsCollection=self.hotNewsCollection;
          NSIndexPath *indexPath = [self.TableNewsList indexPathForSelectedRow];
         destViewController.currentHotNews=[self.hotNewsCollection objectAtIndex:indexPath.row];
     }
    
}



//
//tableview dategate function
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
//-------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotNewsCollection.count;
}
//-----------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"newslistcell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newslistcell"];
       
    }
//    cell.backgroundColor = [UIColor clearColor];
//    cell.backgroundView = [UIView new];
//    cell.selectedBackgroundView = [UIView new];
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
//    backView.backgroundColor = [UIColor clearColor];
//    cell.backgroundView = backView;
    HotNews*temp=[self.hotNewsCollection objectAtIndex:indexPath.row];
    UIImageView *newsImage = (UIImageView *)[cell viewWithTag:101];
    
    [newsImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://zoninapp.com/admin/upload/hot_news_files/%@", temp.news_file]] placeholderImage:[UIImage imageNamed:@"zonin_logo_f"]];
    
    UILabel *cellLbl = (UILabel *)[cell viewWithTag:102];
    [cellLbl setFrame:CGRectMake(80,5,cell.frame.size.width-80, cell.frame.size.height-20)];
    [cellLbl setNeedsLayout];
    [cellLbl setNeedsDisplay];
    cell.backgroundColor = [UIColor clearColor];
    //[cell.contentView addSubview:cellLbl];
    cellLbl.text=temp.news_title;
    
    UILabel *datelbl = (UILabel *)[cell viewWithTag:103];
    datelbl.text=temp.news_date;
    return cell;
}
//------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    CGFloat lRetval = 10;
//    CGSize maximumLabelSize = CGSizeMake(231, FLT_MAX);
//    CGSize expectedLabelSize;
//    
//     HotNews*temp=[self.hotNewsCollection objectAtIndex:indexPath.row];
//    CGFloat numberoflines = [temp.news_title length]/17.0;
//    
//    if (indexPath.section == 0) {
//        expectedLabelSize = [temp.news_title sizeWithFont:[UIFont systemFontOfSize:16.0]
//                                      constrainedToSize:maximumLabelSize
//                                          lineBreakMode:NSLineBreakByWordWrapping];
//        lRetval = expectedLabelSize.height;
//    }
//    else if(indexPath.section == 1)
//    {
//        expectedLabelSize = [secondcellText sizeWithFont:[UIFont systemFontOfSize:16.0]
//                                       constrainedToSize:maximumLabelSize
//                                           lineBreakMode:NSLineBreakByWordWrapping];
//        lRetval = expectedLabelSize.height;
//    }
//    else if (indexPath.section == 2)
//    {
//        expectedLabelSize = [thirdcellText sizeWithFont:[UIFont systemFontOfSize:16.0]
//                                      constrainedToSize:CGSizeMake(231, numberoflines*17.0)
//                                          lineBreakMode:NSLineBreakByWordWrapping];
//        lRetval = expectedLabelSize.height-128.0;
//    }
//    
//    UIImage *factoryImage = [UIImage imageNamed:NSLocalizedString(@"barcode_factory_reset.png", @"")];
//    
//    CGFloat height = factoryImage.size.height;
//    
//    if (lRetval < height) {
//        lRetval = height+15.0;
//    }
//    
//    return lRetval;
    //------------------
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5,300, 9999)];
    label.numberOfLines=0;
    //label.font = [UIFont fontWithName:@"system" size:14];
    HotNews*temp=[self.hotNewsCollection objectAtIndex:indexPath.row];
    label.text = temp.news_title;
    
//    CGSize maximumLabelSize = CGSizeMake(300, 9999);
//    CGSize expectedSize = [label sizeThatFits:maximumLabelSize];
    
 //   CGFloat height = expectedSize.height+20;
//    if (IPAD) {
//        
//    }else{
//        if (height<65) {
//            return 65;
//        }
//    }
    if (IPAD) {
        return 93;
    }else{
        return 62;
    }
    
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
