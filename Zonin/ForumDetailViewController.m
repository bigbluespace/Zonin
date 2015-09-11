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

@interface ForumDetailViewController (){
    AppDelegate *appDelegate;
    CGFloat PORTRAIT_KEYBOARD_HEIGHT, animatedDistance, KEYBOARD_ANIMATION_DURATION;
    float origin;
    NSMutableArray *commentArray;
}
@property (weak, nonatomic) IBOutlet UILabel *topicTitle;
@property (weak, nonatomic) IBOutlet UILabel *topicDescription;
@property (weak, nonatomic) IBOutlet UILabel *topicdate;
@property (weak, nonatomic) IBOutlet UIView *commentOverlayView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *addAdviceView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;


@end

@implementation ForumDetailViewController{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", _forumData);
    _topicTitle.text = [_forumData valueForKey:@"topic_title"];
    _topicDescription.text = [_forumData valueForKey:@"topic_description"];
    _topicdate.text = [_forumData valueForKey:@"topic_date"];
    
    _commentOverlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    _addAdviceView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    PORTRAIT_KEYBOARD_HEIGHT = 270;
    origin = _addAdviceView.frame.origin.y;
    KEYBOARD_ANIMATION_DURATION = 0.3;
    
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}

-(void)loadSelectedForumComment{
    NSLog(@"Topic ID %@", [_forumData valueForKey:@"topic_id"]);
    NSDictionary *dict = @{
                           @"topic_id":[_forumData valueForKey:@"topic_id"],
                           @"MACHINE_CODE":@"emran4axiz"
                           };
    NSString *url = [NSString stringWithFormat:@"http://zoninapp.com/admin/backend/api_zonin/gettopic_comment/emran4axiz/%@",[_forumData valueForKey:@"topic_id"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Zonin commonPost:url parameters:dict block:^(NSDictionary *JSON, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"List Detail %@",JSON);
        if ([[JSON valueForKey:@"message"]isEqualToString:@"success"]) {
            commentArray = [[NSMutableArray alloc] initWithArray:[JSON valueForKey:@"topic_comments_info"]];
            
        }
        [_commentTableView reloadData];
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
    [self loadSelectedForumComment];
}

- (IBAction)showAdviceOverlay:(id)sender {
    _addAdviceView.hidden = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    CGRect textFieldRect = [self.view convertRect:_addAdviceView.bounds fromView:_addAdviceView];
//    [self animateView_Up:&textFieldRect];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [self animateView_Down];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Comment Overlay View & TableView
- (IBAction)closeBtn:(id)sender {
    _commentOverlayView.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    UILabel *title = (UILabel*)[cell viewWithTag:500];
    title.text = [commentArray[indexPath.row] valueForKey:@"topic_comment"];
    return cell;
}

#pragma mark - New Comment Entry

- (IBAction)closeCommentBtn:(id)sender {
    _addAdviceView.hidden = YES;
}

- (IBAction)addCommentBtn:(id)sender {
    NSDictionary *dict = @{
                           @"topic_ids":[_forumData valueForKey:@"topic_id"],
                           @"user_id":[NSString stringWithFormat:@"%d",appDelegate.logedUser.userID],
                           @"topic_comment":_commentTextField.text,
                           @"MACHINE_CODE":@"emran4axiz"
                           };
    NSString *url = [NSString stringWithFormat:@"http://zoninapp.com/admin/backend/api_zonin/comment_save/emran4axiz"];//%@,[_forumData valueForKey:@"topic_id"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Zonin commonPost:url parameters:dict block:^(NSDictionary *JSON, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Success %@",JSON);
        _addAdviceView.hidden = YES;
    }];
}

#pragma mark -animation functions
- (void)animateView_Up: (CGRect*)rect{
    CGFloat fieldBottom =rect->origin.y+rect->size.height;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGRect viewFrame = self.view.frame;
    
    // NSLog(@"%f",viewFrame.origin.y);
    // NSLog(@"%f",origin);
    
    if (fieldBottom<(screenHeight-PORTRAIT_KEYBOARD_HEIGHT) && viewFrame.origin.y == origin) {
        animatedDistance = 0;
        return;
    }    else{
        animatedDistance = fieldBottom - (screenHeight-PORTRAIT_KEYBOARD_HEIGHT);
    }
    
    [self aniamteFields:animatedDistance down:NO];
    
}
- (void) animateView_Down{
    [self aniamteFields:origin down:YES];
}

- (void)aniamteFields:(CGFloat)distance down:(BOOL)down{
    CGRect viewFrame = self.view.frame;
    if (down) {
        viewFrame.origin.y = distance;
    }else{
        viewFrame.origin.y -= distance;
    }
    
    if (viewFrame.origin.y > origin) {
        viewFrame.origin.y = origin;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
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
