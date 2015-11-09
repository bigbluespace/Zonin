//
//  FeedbackVC.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/5/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//
#include "RESideMenu.h"
#import "FeedbackVC.h"
#import "AdViewObject.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface FeedbackVC ()

@end

@implementation FeedbackVC{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feedbackTable.backgroundColor = [UIColor clearColor];
    self.feedbackTable.opaque = NO;
    self.feedbackTable.backgroundView = nil;
    self.feedbackTable.dataSource=self;
    self.feedbackTable.delegate=self;
    // Do any additional setup after loading the view.
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}
//--------------------------------
-(void)viewDidAppear:(BOOL)animated
{
    
}

- (IBAction)headerClicked:(id)sender {
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"home"]]
                                                 animated:YES];
    
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

//--------------------------------
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
//-----------------------------
//table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedbacks.count;
}
//------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[[UITableViewCell alloc]init];
    cell.backgroundColor=[UIColor clearColor];
    Feedback*temp=[self.feedbacks objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines=0;
    cell.textLabel.text=temp.feedback;
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}
//-----------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5,300, 9999)];
    label.numberOfLines=0;
    label.font = [UIFont fontWithName:@"system" size:14];
     Feedback*temp=[self.feedbacks objectAtIndex:indexPath.row];
    label.text = temp.feedback;
    CGSize maximumLabelSize = CGSizeMake(300, 9999);
    CGSize expectedSize = [label sizeThatFits:maximumLabelSize];
    return expectedSize.height+20;
}
@end
