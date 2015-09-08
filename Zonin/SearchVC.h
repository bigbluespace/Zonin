//
//  SearchVC.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/28/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "SearchView.h"
#import "HotNews.h"
#import "NewsListVC.h"

@interface SearchVC : UIViewController<searchViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
