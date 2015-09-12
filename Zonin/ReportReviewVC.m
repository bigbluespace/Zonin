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

@interface ReportReviewVC ()

@end

@implementation ReportReviewVC{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isCrimeReport)
    {
        NSLog(@"getting crime");
      self.tableItems = [Crime getAllCrime];
    }
    else
    {
        NSLog(@"getting reviews");
       self.tableItems=[OfficerReviews GetAllReview];
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
    if (self.isCrimeReport)
    {
        //for review
        cell =[tableView dequeueReusableCellWithIdentifier:@"reviewreportcell"];
        UILabel *cellLbl = (UILabel *)[cell viewWithTag:2];
        [cellLbl setFrame:CGRectMake(80,5,cell.frame.size.width-80, cell.frame.size.height-20)];
        [cellLbl setNeedsLayout];
        [cellLbl setNeedsDisplay];
        cellLbl.numberOfLines=0;
       // cell.lineBreakMode=
        //reviewreportcell
        OfficerReviews*temp=[self.tableItems objectAtIndex:indexPath.row];
        cellLbl.text = temp.officer_name;
            UILabel *cellLbl2nd = (UILabel *)[cell viewWithTag:3];
        cellLbl2nd.text=[NSString stringWithFormat:@"%@,%@",temp.country_name,temp.state_name];
    }
    else
    {
        // for crime
        Crime*temp=[self.tableItems objectAtIndex:indexPath.row];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.text=temp.crime_title;

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
