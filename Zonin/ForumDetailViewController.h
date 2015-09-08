//
//  ForumDetailViewController.h
//  Zonin
//
//  Created by Rezaul Karim on 5/9/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property NSDictionary *forumData;
@end
