//
//  KeyboardToolbar.m
//  Zonin
//
//  Created by Admin on 21/09/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "KeyboardToolbar.h"



@implementation KeyboardToolbar


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextButton.frame = CGRectMake(0, 0, 30, 46);
        [self.nextButton setImage:[UIImage imageNamed:@"picker-next"] forState:UIControlStateNormal];
        [self.nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:self.nextButton];
        
        
        
        self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.previousButton.frame = CGRectMake(0, 0, 30, 46);
        [self.previousButton setImage:[UIImage imageNamed:@"picker-prev"] forState:UIControlStateNormal];
        [self.previousButton addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *pevButton = [[UIBarButtonItem alloc] initWithCustomView:self.previousButton];
        
        
        self.toolbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 100, 21.0f)];
        [self.toolbarTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [self.toolbarTitle setBackgroundColor:[UIColor clearColor]];
        [self.toolbarTitle setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        [self.toolbarTitle setText:@"Title"];
        [self.toolbarTitle setTextAlignment:NSTextAlignmentCenter];
        
        UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:self.toolbarTitle];
        
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                       target:self action:@selector(done)];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 20;
        
        NSArray *toolbarItems = [NSArray arrayWithObjects: pevButton, nextButton, flexibleItem, title, flexibleItem, doneButton, nil];
        
        
        [self setBarStyle:UIBarStyleDefault];
        [self setItems:toolbarItems];
        [self setTintColor:[UIColor whiteColor]];
        //[toolBar setBarTintColor:[UIColor colorWithRed:22.0/255.0 green:110.0/255.0 blue:209.0/255.0 alpha:1.0]];
        [self setBackgroundImage:[UIImage imageNamed:@"toolbar_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    return self;
}

-(void)hideLeftButtons:(BOOL)value{
    
    self.nextButton.hidden = value;
    self.previousButton.hidden = value;
    
}

-(void)setBarTitle:(NSString *)text{
    self.toolbarTitle.text = text;
}


-(void) next{
    [self.delegate keyboardNext];
}
-(void) previous{
    [self.delegate keyboardPrevious];
}

-(void) done{
    [self.delegate keyboardDone];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end