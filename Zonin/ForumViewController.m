//
//  ForumViewController.m
//  Zonin
//
//  Created by Rezaul Karim on 5/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "ForumViewController.h"
#import "MBProgressHUD.h"
#import "RESideMenu.h"
#import "Zonin.h"
#import "ForumDetailViewController.h"
#import "AdViewObject.h"

@interface ForumViewController (){
    NSMutableArray *listData;
    NSDictionary *selected_data;
}

@property (weak, nonatomic) IBOutlet UITableView *forumTableView;
@property (weak, nonatomic) IBOutlet UIButton *communityConcern;
@property (weak, nonatomic) IBOutlet UIButton *officersConcern;

@end

@implementation ForumViewController
{
    UIView*SpinnerView;
    __weak IBOutlet UIView *adView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    listData = [NSMutableArray array];
    
    _communityConcern.titleLabel.textAlignment = NSTextAlignmentCenter;
    _officersConcern.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navigationController.navigationBarHidden = YES;
    [self loadListData];
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}

-(void)loadListData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{
                             @"MACHINE_CODE":@"emran4axiz"
                             };
    [Zonin commonPost:@"http://zoninapp.com/admin/backend/api_zonin/get_topic/emran4axiz" parameters:params block:^(NSDictionary *JSON, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[JSON valueForKey:@"message"] isEqualToString:@"success"]) {
            listData = [[NSMutableArray alloc] initWithArray:[JSON valueForKey:@"status"]];
        }
        [_forumTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"corcenlistcell" forIndexPath:indexPath];
    UILabel *header = (UILabel*)[cell viewWithTag:501];
    UILabel *detail = (UILabel*)[cell viewWithTag:502];
    
    header.text = [listData[indexPath.row] valueForKey:@"topic_title"];
    detail.text = [listData[indexPath.row] valueForKey:@"topic_date"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selected_data = listData[indexPath.row];
    [self performSegueWithIdentifier:@"forumDetailSegue" sender:self];
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ((ForumDetailViewController*)segue.destinationViewController).forumData = selected_data;
}


@end
