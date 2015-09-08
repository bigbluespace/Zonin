//
//  ReportReviewVC.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrimeReviewDetailVC.h"
#import "OfficerReviews.h"
#import "Crime.h"

@interface ReportReviewVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *reportTable;
@property NSArray* tableItems;
//bool if is report
@property bool isCrimeReport;
@end
