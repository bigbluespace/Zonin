//
//  CrimeReviewDetailVC.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/13/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackVC.h"
#import "FeedBackView.h"
#import "Crime.h"
#import "OfficerReviews.h"

@interface CrimeReviewDetailVC : UIViewController<UITableViewDataSource,UITableViewDelegate,FeedbackViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailTable;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property id object;
@property BOOL isCrime;

@end
