//
//  FeedbackVC.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/5/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feedback.h"

@interface FeedbackVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *feedbackTable;
@property NSArray* feedbacks;

@end
