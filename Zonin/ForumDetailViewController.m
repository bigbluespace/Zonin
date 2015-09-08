//
//  ForumDetailViewController.m
//  Zonin
//
//  Created by Rezaul Karim on 5/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "ForumDetailViewController.h"
#import "MBProgressHUD.h"
#import "Zonin.h"
#import "RESideMenu.h"
#import "AdViewObject.h"

@interface ForumDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *topicTitle;
@property (weak, nonatomic) IBOutlet UILabel *topicDescription;
@property (weak, nonatomic) IBOutlet UILabel *topicdate;
@property (weak, nonatomic) IBOutlet UIView *commentOverlayView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *addAdviceView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;


@end

@implementation ForumDetailViewController{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _topicTitle.text = [_forumData valueForKey:@"topic_title"];
    _topicDescription.text = [_forumData valueForKey:@"topic_description"];
    _topicdate.text = [_forumData valueForKey:@"topic_date"];
    
    _commentOverlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    _addAdviceView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self loadSelectedForumComment];
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}

-(void)loadSelectedForumComment{
    NSDictionary *dict = @{
                           @"topic_id":[_forumData valueForKey:@"topic_id"],
                           @"MACHINE_CODE":@"emran4axiz"
                           };
    NSString *url = [NSString stringWithFormat:@"http://zoninapp.com/admin/backend/api_zonin/gettopic_comment/emran4axiz"];//%@,[_forumData valueForKey:@"topic_id"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Zonin commonPost:url parameters:dict block:^(NSDictionary *JSON, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"List Detail %@",JSON);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)viewCommentBtn:(id)sender {
    _commentOverlayView.hidden = NO;
}

- (IBAction)showAdviceOverlay:(id)sender {
    _addAdviceView.hidden = NO;
}

#pragma mark - Comment Overlay View & TableView
- (IBAction)closeBtn:(id)sender {
    _commentOverlayView.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    UILabel *title = (UILabel*)[cell viewWithTag:500];
    
    title.text = @"Sample";
    return cell;
}

#pragma mark - New Comment Entry

- (IBAction)closeCommentBtn:(id)sender {
    _addAdviceView.hidden = YES;
}

- (IBAction)addCommentBtn:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
