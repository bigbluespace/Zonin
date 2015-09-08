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

@interface CrimeReviewDetailVC ()
{
    NSArray* crimeSubjectContent;
    NSArray* reviewSubjectContent;
    AppDelegate* myAppdelegate;
    ASStarRatingView* rating;

}

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
    // Do any additional setup after loading the view.
    //content arry
    crimeSubjectContent=[[NSArray alloc]initWithObjects:@"1. Crime Title",@"2. Crime Date",@"3. Crime Time ",@"4. Country",@"5. State",@"6. location ",@"7. Details",@"8. User Email",@"9. Reported Date",nil];
    reviewSubjectContent=[[NSArray alloc]initWithObjects:@"1. Review for",@"2. Agency",@"3. Rating Graph ",@"4. Country",@"5. State",@"6. User name ",@"7. Date submited",nil];
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//----------------
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
        return reviewSubjectContent.count;
    }
}
//--------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"detailcell"];
    UILabel*lblright=(UILabel*)[cell viewWithTag:102];
    UILabel*lblleft=(UILabel*)[cell viewWithTag:103];
    [lblleft setFrame:CGRectMake(5,0,cell.frame.size.width/2-5, cell.frame.size.height)];
    [lblleft setNeedsLayout];
    [lblleft setNeedsDisplay];
    @try
    {
   
    if (self.isCrime)
    {
        Crime*temp=(Crime*)self.object;
     lblleft.text=[crimeSubjectContent objectAtIndex:indexPath.row];
         NSLog(@"table subject cell :%d,%@",indexPath.row,temp.crime_date);
        
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
    
            OfficerReviews* temp=(OfficerReviews*)self.object;
            lblleft.text=[reviewSubjectContent objectAtIndex:indexPath.row];
            NSLog(@"table subject cell :%d,%@",indexPath.row,temp.review_date);
        lblright.text = @"date";
            if (indexPath.row==0)
            {
                lblright.text = temp.review_for;
            }
            if (indexPath.row==1)
            {
                lblright.text = temp.agency;
            }
            if (indexPath.row==2)
            {
                lblright.text = temp.review_details;
            }
            if (indexPath.row==3)
            {
                lblright.text = [NSString stringWithFormat:@" %@",temp.country_name];
            }
            if (indexPath.row==4)
            {
                lblright.text = [NSString stringWithFormat:@" %@",temp.state_name];
            }
            if (indexPath.row==5)
            {
                lblright.text = [NSString stringWithFormat:@" %@ %@",temp.f_name,temp.l_name];
            }
            if (indexPath.row==6)
            {
                
                lblright.text = [NSString stringWithFormat:@" %@",temp.review_date];
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
    return cell ;
}
//
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
    if (!self.isCrime)
    {

   // OfficerReviews*temp=[self.tableItems objectAtIndex:indexPath.row];
        OfficerReviews*temp=(OfficerReviews*)self.object;
        if (indexPath.row==0)
        {
            label.text = temp.review_for;
        }
        if (indexPath.row==2)
        {
            label.text = temp.review_details;
        }
        else
        {
            label.text = @"one line for any others";
        }
    }
    if (self.isCrime)
    {

        Crime*temp=(Crime*)self.object;
        if (indexPath.row==0)
        {
            label.text = temp.crime_title;
        }
        if (indexPath.row==6)
        {
            label.text = temp.crime_desc;
        }
        else
        {
       label.text = @"one line for any others";
        }
    }

    CGSize maximumLabelSize = CGSizeMake(300, 9999);
    CGSize expectedSize = [label sizeThatFits:maximumLabelSize];
    return expectedSize.height+20;

}
@end
