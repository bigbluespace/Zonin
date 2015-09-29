//
//  KeyboardToolbar.h
//  Zonin
//
//  Created by Admin on 21/09/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KeyboardToolbarDelegates <NSObject>
@optional
- (void)keyboardNext;
- (void)keyboardPrevious;
- (void)keyboardDone;
@end


@interface KeyboardToolbar : UIToolbar

@property (nonatomic, weak) id <KeyboardToolbarDelegates> delegate;
@property UILabel *toolbarTitle;
@property UIButton *previousButton;
@property UIButton *nextButton;


- (void)hideLeftButtons:(BOOL)value;
- (void)setBarTitle:(NSString*)text;
@end