//
//  CrimeReviewDetailVC.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/13/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "CrimeReviewDetailVC.h"
#import "AppDelegate.h"
#import "RESideMenu.h"
#import "AdViewObject.h"
#import "IncidentSearch.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface CrimeReviewDetailVC ()
{
    NSArray* crimeSubjectContent;
    NSArray* reviewSubjectContent;
    NSArray* reviewFeedbackArray;
    AppDelegate* myAppdelegate;
    ASStarRatingView* rating;
    BOOL isAttachment;

}
@property (weak, nonatomic) IBOutlet UIView *feedbackView;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIView *lowerView;
@property (weak, nonatomic) IBOutlet UIView *allReviewView;
@property (weak, nonatomic) IBOutlet UITableView *reviewTable;



@end

@implementation CrimeReviewDetailVC{
    __weak IBOutlet UIView *adView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //tableview apearence
    myAppdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.detailTable.backgroundColor = [UIColor clearColor];
    self.detailTable.opaque = NO;
    self.detailTable.backgroundView = nil;
    self.detailTable.allowsSelection=NO;
    self.detailTable.dataSource=self;
    self.detailTable.delegate=self;
    
    UIView *footerView = self.detailTable.tableFooterView;
    CGRect newFrame = footerView.frame;
    if (self.isCrime) {
        newFrame.size.height = IPAD ? 100 : 60;
        _upperView.hidden = YES;
        _lowerView.hidden = YES;
    }
    else{
        newFrame.size.height = IPAD ? 200 : 120;
        _feedbackView.hidden = YES;
        reviewFeedbackArray = [self.object valueForKeyPath:@"review_feedback"];
    }
    
    footerView.frame = newFrame;
    [self.detailTable setTableFooterView:footerView];
    // Do any additional setup after loading the view.
    //content arry
    crimeSubjectContent=[[NSArray alloc]initWithObjects:@"1. Incident Title:",@"2. Incident Date:",@"3. Incident Time:",@"4. Country:",@"5. State/Province:",@"6. Location:",@"7. Details of Incident:",@"8. User Name:",@"9. Reported Date:",nil];
    reviewSubjectContent=[[NSArray alloc]initWithObjects:@"1. Review for",@"2. Agency",@"3. Rating Graph ",@"4. Country",@"5. State",@"6. User name ",@"7. Date submited",nil];
    
    
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//----------------

- (IBAction)searchReview:(id)sender {
    IncidentSearch *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"incidentSearch"];
    vc.isIncident = NO;
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)addReview:(id)sender {
    
    
    if (myAppdelegate.logedUser.userID<=0)
    {
        [self TostAlertMsg:@"Login to add feedback"];
        return;
    }
    
    FeedBackView *feedview=[[FeedBackView alloc]init];
    feedview.ratingViewContainer.hidden=FALSE;
    NSArray*nibs=[[NSBundle mainBundle] loadNibNamed:@"feedback"
                                               owner:self options:nil];
    feedview=[nibs objectAtIndex:0];
    [feedview setFrame:CGRectMake(0, 20,self.containerView.bounds.size.width, 150)];
    rating=[[ASStarRatingView alloc]initWithFrame:feedview.ratingViewContainer.bounds];
    rating.canEdit=YES;
    [feedview.ratingViewContainer addSubview:rating];
    //feedview.backgroundColor=[UIColor clearColor];
    feedview.delegate=self;
    
    // feedview.center=self.NewsImage.center;
    [self.containerView addSubview:feedview];
    //code here for review feedback

}
- (IBAction)readAllReviews:(id)sender {
    isAttachment = NO;
    
        [_reviewTable reloadData];
    _allReviewView.hidden = NO;
    
    
}
- (IBAction)closeAllReview:(id)sender {
    _allReviewView.hidden = YES;
    
    
}
- (IBAction)viewAttachments:(id)sender {
    
    //NSString *url = [NSString stringWithFormat:@"get_all_review_attachment/%@/emran4axiz", ];
    isAttachment = YES;
    [_reviewTable reloadData];
     _allReviewView.hidden = NO;
   
    
    
}


- (IBAction)ViewFeedback:(id)sender
{
     FeedbackVC*fvc=[self.storyboard instantiateViewControllerWithIdentifier:@"feedbackvc"];
    if (self.isCrime)
    {
        Crime* temp=(Crime*)self.object;
        fvc.feedbacks= [temp getFeedback];

    }
    else
    {
        OfficerReviews* temp=(OfficerReviews*)self.object;
        fvc.feedbacks= [temp getFeedback];
    }
    if (fvc.feedbacks.count<=0)
    {
        [self TostAlertMsg:@"no feedback found"];
        return;
    }
    [self.navigationController pushViewController:fvc animated:YES];
}
//-----------------------
- (IBAction)addFeedback:(id)sender
{
    if (myAppdelegate.logedUser.userID<=0)
    {
        [self TostAlertMsg:@"Login to add feedback"];
        return;
    }
    if (self.isCrime)
    {
        FeedBackView *feedview=[[FeedBackView alloc]init];
        NSArray*nibs=[[NSBundle mainBundle] loadNibNamed:@"feedback"
                                                   owner:self options:nil];
        feedview=[nibs objectAtIndex:0];
        feedview.ratingViewContainer.hidden=YES;
        feedview.delegate=self;
        [feedview setFrame:CGRectMake(0, 20,self.containerView.bounds.size.width, 150)];
       // feedview.center=self.NewsImage.center;
        [self.containerView addSubview:feedview];
  
    }
    else
    {
           }
 
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//feadback deledate
-(void)TouchOnAddfeedBack:(NSString *)Feedback
{
    if (self.isCrime)
    {
        Crime*temp=(Crime*)self.object;
        [temp addFeedback:Feedback];
    }
    else
    {
        NSLog(@"rating %f",rating.rating);
        
        
        OfficerReviews*temp=(OfficerReviews*)self.object;
        [temp addFeedback:Feedback andRating:rating.rating andUserID:myAppdelegate.logedUser.userID];
        //code here for review feedback
    }
    
}
//tableview deledate function
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//--------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isCrime)
    {
        return  crimeSubjectContent.count;
    }
    else
    {
        if (tableView.tag == 1000) {
             return reviewSubjectContent.count;
        }else{
           
            return reviewFeedbackArray.count;
        }
       
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    if (tableView.tag == 1000) {
        
    
    cell =[tableView dequeueReusableCellWithIdentifier:@"detailcell"];
    UILabel*lblright=(UILabel*)[cell viewWithTag:102];
    UILabel*lblleft=(UILabel*)[cell viewWithTag:103];
    //[lblleft setFrame:CGRectMake(5,0,cell.frame.size.width/2-5, cell.frame.size.height)];
    [lblleft setNeedsLayout];
    [lblleft setNeedsDisplay];
   
    @try
    {
   
    if (self.isCrime)
    {
        Crime*temp=(Crime*)self.object;
     lblleft.text=[crimeSubjectContent objectAtIndex:indexPath.row];
         NSLog(@"table subject cell :%ld,%@",(long)indexPath.row,temp.crime_date);
        
        if (indexPath.row==0)
        {
            lblright.text = temp.crime_title;
        }
        if (indexPath.row==1)
        {
            lblright.text = [NSString stringWithFormat:@"%@",temp.crime_date];
        }
        if (indexPath.row==2)
        {
            lblright.text = [NSString stringWithFormat:@"%@",temp.report_time];
        }
        if (indexPath.row==3)
        {
            lblright.text = [NSString stringWithFormat:@"%@",temp.country_name];
        }
        if (indexPath.row==4)
        {
            lblright.text =[NSString stringWithFormat:@"%@",temp.state_name];;
        }
        if (indexPath.row==5)
        {
            lblright.text = [NSString stringWithFormat:@"%@",temp.crime_location];
        }
        if (indexPath.row==6)
        {
            lblright.text = temp.crime_desc;
        }
        if (indexPath.row==7)
        {
            lblright.text = [NSString stringWithFormat:@"%@",temp.User_email];
        }
        if (indexPath.row==8)
        {
            lblright.text = [NSString stringWithFormat:@"%@",temp.report_date];
        }
        

    }
    else
    {
    
         //   OfficerReviews* temp=(OfficerReviews*)self.object;
            lblleft.text=[reviewSubjectContent objectAtIndex:indexPath.row];
           // NSLog(@"table subject cell :%d,%@",indexPath.row,temp.review_date);
       // lblright.text = @"date";
            if (indexPath.row==0)
            {
                lblright.text = [self.object valueForKeyPath:@"review.review_for"];
            }
            if (indexPath.row==1)
            {
                lblright.text = [self.object valueForKeyPath:@"review.agency"];
            }
            if (indexPath.row==2)
            {
                cell =[tableView dequeueReusableCellWithIdentifier:@"graphCell"];
                
                UILabel*lblleft=(UILabel*)[cell viewWithTag:104];
                lblleft.text=[reviewSubjectContent objectAtIndex:indexPath.row];
                
                UIImageView *graphImage = (UIImageView*)[cell viewWithTag:105];
                [graphImage setImageWithURL:[NSURL URLWithString:[self.object valueForKeyPath:@"review.rating_graph"]] placeholderImage:[UIImage imageNamed:@""]];
            }
            if (indexPath.row==3)
            {
                lblright.text = [NSString stringWithFormat:@" %@",[self.object valueForKeyPath:@"review.country_name"]];
            }
            if (indexPath.row==4)
            {
                lblright.text = [NSString stringWithFormat:@" %@",[self.object valueForKeyPath:@"review.state_name"]];
            }
            if (indexPath.row==5)
            {
                lblright.text = [NSString stringWithFormat:@" %@ %@",[self.object valueForKeyPath:@"review.f_name"],[self.object valueForKeyPath:@"review.l_name"]];
            }
            if (indexPath.row==6)
            {
                
                lblright.text = [NSString stringWithFormat:@" %@",[self.object valueForKeyPath:@"review.review_date"]];
            }
       
    }
    }
    @catch (NSException *exception)
    {
        NSLog(exception.description);
    }
    @finally
    {
        //
    }
    }else{
        
        if (isAttachment) {
            cell =[tableView dequeueReusableCellWithIdentifier:@"picCell"];
            
            UIImageView *picCell = (UIImageView*)[cell viewWithTag:2004];
            
            
            NSString *filePath = [NSString stringWithFormat:@"http://zoninapp.com/admin/upload/review_files/%@", [reviewFeedbackArray[indexPath.row] valueForKeyPath:@"review_feedback_files"]];
            
            [picCell setImageWithURL:[NSURL URLWithString:filePath] placeholderImage:[UIImage imageNamed:@"loading.png"]];
            
            
        }else{
        
        
        
        cell =[tableView dequeueReusableCellWithIdentifier:@"reviewCell"];
        
        UILabel *userNameLabel = (UILabel*)[cell viewWithTag:2001];
        UILabel *reviewLabel = (UILabel*)[cell viewWithTag:2002];
        UILabel *dateLabel = (UILabel*)[cell viewWithTag:2003];
        
        userNameLabel.text = [NSString stringWithFormat:@"User NAme: %@ %@",[reviewFeedbackArray[indexPath.row] valueForKeyPath:@"f_name"], [reviewFeedbackArray[indexPath.row] valueForKeyPath:@"l_name"]];
        
        reviewLabel.text = [NSString stringWithFormat:@"Review: %@ (%@)",[reviewFeedbackArray[indexPath.row] valueForKeyPath:@"review_feedback_desc"], [reviewFeedbackArray[indexPath.row] valueForKeyPath:@"review_rating"]];
        
        dateLabel.text = [NSString stringWithFormat:@"Date Submitted: %@",[reviewFeedbackArray[indexPath.row] valueForKeyPath:@"review_feedback_date"]];
        }
        
    }
     cell.backgroundColor = [UIColor clearColor];
    return cell ;
}
//
- (IBAction)headerClicked:(id)sender {
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"home"]]
                                                 animated:YES];
    
}

-(NSString*)MakeFromNullString:(NSString*)input
{
    if (!input)
    {
        input=@" ";
    }
    return input;
}
//-----------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0,300, 9999)];
    label.numberOfLines=0;
    label.font = [UIFont fontWithName:@"system" size:14];
    label.text = @"one line for any others";

    if (!self.isCrime)
    {
        if (tableView.tag == 2000) {
            if (isAttachment) {
                return IPAD? 600 : 400;
            }
            return IPAD? 150 : 100;
        }

   // OfficerReviews*temp=[self.tableItems objectAtIndex:indexPath.row];
        //OfficerReviews*temp=(OfficerReviews*)self.object;
        if (indexPath.row==0)
        {
            if (![[self.object valueForKeyPath:@"review.review_for"] isEqualToString:@""]) {
            label.text = [self.object valueForKeyPath:@"review.review_for"];
            }}
        if (indexPath.row==2)
        {
            return IPAD? 150 : 100;
           // label.text = temp.review_details;
        }
        
    }
    if (self.isCrime)
    {

        Crime*temp=(Crime*)self.object;
        
        
        if (indexPath.row==0)
        {
            NSLog(@"expected title: %@", temp.crime_title);
            if (![temp.crime_title isEqualToString:@""]) {
                
                label.text = temp.crime_title;

            }

        }
        if (indexPath.row==6)
        {
            NSLog(@"expected location : %@", temp.crime_desc);
            if (![temp.crime_desc isEqualToString:@""]) {
                
                label.text = temp.crime_desc;
            }

            
        }
    }

    CGSize maximumLabelSize = CGSizeMake(300, 9999);
    CGSize expectedSize = [label sizeThatFits:maximumLabelSize];
    NSLog(@"expected height: %f", expectedSize.height);
    return expectedSize.height+20;

}
@end
