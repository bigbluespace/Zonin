//
//  CustomToolbar.h
//  Zonin
//
//  Created by Admin on 29/09/15.
//  Copyright © 2015 UBITRIX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomToolbarDelegate <NSObject>

-(void)toolbarNext;
-(void)toolbarPrevious;
-(void)toolbarDone;


@end

@interface CustomToolbar : UIToolbar

@property (nonatomic, weak) id <CustomToolbarDelegate> delegate;

-(void)setBarTitle:(NSString*)text;

@end
