//
//  FeedBackView.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 7/2/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "FeedBackView.h"

@implementation FeedBackView
{
    ASStarRatingView*rating;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(void)awakeFromNib
//{
//    NSLog(@"awake .......");
//    if(!self.isWithRating)
//    { NSLog(@"awake ......qqq.");
//       // self.ratingViewContainer.hidden=TRUE;
//    }
//   
//}
- (IBAction)btnCancleTouch:(id)sender
{
    [self removeFromSuperview];
}
- (IBAction)btnTouchAdd:(id)sender {
    if ([self.txtFeedBack.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0)
    {
        [self.delegate  TouchOnAddfeedBack:self.txtFeedBack.text];
        [self removeFromSuperview];
    }
    else
    {
        [self TostAlertMsg:@"Write Feedback"];
        NSLog(@"enter feedback");
    }
}
//------------------------------
//---------------
//showig tost
-(void)TostAlertMsg:(NSString*)alertmsg
{
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertmsg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}
@end
