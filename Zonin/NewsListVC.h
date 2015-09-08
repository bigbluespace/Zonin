//
//  NewsListVC.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/21/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotNews.h"
#import "HotNewsViewController.h"
#import "SearchView.h"

@interface NewsListVC : UIViewController<UITableViewDataSource,UITableViewDelegate, searchViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TableNewsList;
@property NSArray*hotNewsCollection;
@property (weak, nonatomic) IBOutlet UIView *containerView;


@end
