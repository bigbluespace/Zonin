//
//  HotNewsViewController.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/15/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "App-Utilities.h"
#import "HotNews.h"
#import "NewsListVC.h"
#import "UWebOparetion.h"
#import "SearchView.h"
#import "Country.h"
#import "FeedBackView.h"
#import "FeedbackVC.h"

#import <MediaPlayer/MediaPlayer.h>


@interface HotNewsViewController : UIViewController<UITextFieldDelegate,searchViewDelegate,FeedbackViewDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblNewsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNewsDate;
@property (weak, nonatomic) IBOutlet UIView *NewsContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *NewsImage;
@property (weak, nonatomic) UITextView *NewsBodyText;
@property (weak, nonatomic) IBOutlet UIView *NewsNavigationView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewTitle;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *SearchHotNewsView;


//hot news object contain infromation for displaying hot news
//
@property (nonatomic,setter=setCurrentHotNews:)HotNews* currentHotNews;
@property NSArray*hotnewsCollection;
@property MPMoviePlayerController *moviePlayer;
@end
