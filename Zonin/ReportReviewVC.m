//
//  ReportReviewVC.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "ReportReviewVC.h"
#include "RESideMenu.h"
#import "AdViewObject.h"
#import "IncidentSearch.h"
#import "AddReViewController.h"
#import "AddCrimeViewController.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface ReportReviewVC ()

@property (weak, nonatomic) IBOutlet UIButton *leftLowerBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightLowerBtn;

@property (weak, nonatomic) IBOutlet UILabel *leftBtnLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBtnLabel;



@end

@implementation ReportReviewVC{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isCrimeReport)
    {
        NSLog(@"getting crime");
        if (self.tableItems == nil || self.tableItems == (id)[NSNull null]) {
            self.tableItems = [Crime getAllCrime];
        }
      
        _leftBtnLabel.text = @"SEARCH AN INCIDENT REPORT";
        _rightBtnLabel.text = @"REPORT AN INCIDENT";
        
    }
    else
    {
        NSLog(@"getting reviews");
        if (self.tableItems == nil || self.tableItems == (id)[NSNull null]) {
            self.tableItems=[OfficerReviews GetAllReview];
        }
       
        _leftBtnLabel.text = @"SEARCH A REVIEW";
        _rightBtnLabel.text = @"ADD A NEW REVIEW";

    }
   // NSLog(@"number of table items %d",self.tableItems.count);
    self.reportTable.backgroundColor = [UIColor clearColor];
    self.reportTable.opaque = NO;
    self.reportTable.backgroundView = nil;
    self.reportTable.dataSource=self;
    self.reportTable.delegate=self;
    // Do any additional setup after loading the view.
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}
- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
//----------------------------------
-(void)viewDidAppear:(BOOL)animated
{
    [self.reportTable reloadData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while (self.tableItems.count==0)
        {
            ;
        }
        if (self.tableItems.count>0)
              {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [self.reportTable reloadData];
               
                });
                  
            }
        
       
    });

}

//------------------------------
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
//
//table view dalegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//---------------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableItems.count;
}
//-----------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor clearColor];
    if (self.isCrimeReport)
    {
        //for review
        cell =[tableView dequeueReusableCellWithIdentifier:@"incidentCell"];
        
        UILabel *cellLbl = (UILabel *)[cell viewWithTag:2];
        UILabel *cellLbl2nd = (UILabel *)[cell viewWithTag:3];
       
        //OfficerReviews*temp=[self.tableItems objectAtIndex:indexPath.row];
        //cellLbl.text = temp.officer_name;
        
        //cellLbl2nd.text=[NSString stringWithFormat:@"%@,%@",temp.country_name,temp.state_name];
        cellLbl.text = [[self.tableItems objectAtIndex:indexPath.row] valueForKeyPath:@"crime_title"];
        cellLbl2nd.text=[NSString stringWithFormat:@"%@ - %@",[[self.tableItems objectAtIndex:indexPath.row] valueForKeyPath:@"country_name"],[[self.tableItems objectAtIndex:indexPath.row] valueForKeyPath:@"state_name"]];
    }
    else
    {
        // for crime
        cell =[tableView dequeueReusableCellWithIdentifier:@"reviewCell"];
        
        UILabel *cellLbl = (UILabel *)[cell viewWithTag:2];
        UILabel *cellLbl2nd = (UILabel *)[cell viewWithTag:3];
        
        OfficerReviews*temp=[self.tableItems objectAtIndex:indexPath.row];


        cellLbl.text = temp.officer_name;
        cellLbl2nd.text=[NSString stringWithFormat:@"%@ - %@",temp.country_name,temp.state_name];

    }
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}
//----------------------------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrimeReviewDetailVC* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"reportfeedback"];
    vc.isCrime=self.isCrimeReport;
    if (self.isCrimeReport)
    {
   Crime*temp=[self.tableItems objectAtIndex:indexPath.row];
    NSLog(@"crime id is %d",temp.crime_id);
    vc.object=temp;
    }
    else
    {
            OfficerReviews*temp=[self.tableItems objectAtIndex:indexPath.row];
            NSLog(@"crime id is %d",temp.review_id);
            vc.object=temp;
    }
   // [temp getFeedback];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IPAD) {
        return 93;
    }
    return 65;
}
- (IBAction)leftLowerBtnClick:(id)sender {
    
    if (self.isCrimeReport)
    {
        IncidentSearch *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"incidentSearch"];
        vc.isIncident = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else
    {
        IncidentSearch *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"incidentSearch"];
        vc.isIncident = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)rightLowerBtnClick:(id)sender {
    if (self.isCrimeReport)
    {
        AddCrimeViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"addCrimeView"];
        [self.navigationController pushViewController:cv animated:YES];
    }
    else
    {
        AddReViewController *rc = [self.storyboard instantiateViewControllerWithIdentifier:@"addReViewController"];
        [self.navigationController pushViewController:rc animated:YES];
        
    }
}


//-----------------------
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//    
//    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5,300, 9999)];
//    label.numberOfLines=0;
//    label.font = [UIFont fontWithName:@"system" size:14];
//    if (!self.isCrimeReport)
//    {
//  
//    OfficerReviews*temp=[self.tableItems objectAtIndex:indexPath.row];
//    label.text = temp.review_details;
//    }
//    if (self.isCrimeReport)
//    {
//        
//        Crime*temp=[self.tableItems objectAtIndex:indexPath.row];
//        label.text = temp.crime_title;
//    }
//    
//    CGSize maximumLabelSize = CGSizeMake(300, 9999);
//    CGSize expectedSize = [label sizeThatFits:maximumLabelSize];
//    return expectedSize.height+20;
//    
//}
@end
