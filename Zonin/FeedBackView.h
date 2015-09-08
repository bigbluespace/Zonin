//
//  FeedBackView.h
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/2/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"
@protocol FeedbackViewDelegate;

@interface FeedBackView : UIView
@property (weak, nonatomic) IBOutlet UITextField *txtFeedBack;
@property (weak, nonatomic) IBOutlet UIView *ratingViewContainer;

@property(nonatomic,assign)id<FeedbackViewDelegate> delegate;
@property BOOL isWithRating;
@end

@protocol FeedbackViewDelegate <NSObject>
@optional

-(void)TouchOnAddfeedBack:(NSString*)Feedback;
-(void)TouchOnAddfeedBack:(NSString*)Feedback andRating:(float)Rating;

@end