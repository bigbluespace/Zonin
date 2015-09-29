//
//  CustomToolbar.m
//  Zonin
//
//  Created by Admin on 29/09/15.
//  Copyright © 2015 UBITRIX. All rights reserved.
//

#import "CustomToolbar.h"


@implementation CustomToolbar
UILabel* toolbarTitle;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *next_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        next_btn.frame = CGRectMake(0, 0, 30, 46);
        [next_btn setImage:[UIImage imageNamed:@"picker-next"] forState:UIControlStateNormal];
        [next_btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:next_btn];
        
        UIButton *prev_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        prev_btn.frame = CGRectMake(0, 0, 30, 46);
        [prev_btn setImage:[UIImage imageNamed:@"picker-prev"] forState:UIControlStateNormal];
        [prev_btn addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *pevButton = [[UIBarButtonItem alloc] initWithCustomView:prev_btn];
        
        toolbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 100, 21.0f)];
        [toolbarTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [toolbarTitle setBackgroundColor:[UIColor clearColor]];
        [toolbarTitle setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        [toolbarTitle setText:@"Title"];
        [toolbarTitle setTextAlignment:NSTextAlignmentCenter];
        
        UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:toolbarTitle];
        
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                       target:self action:@selector(done)];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 20;
        
        NSArray *toolbarItems = [NSArray arrayWithObjects: pevButton, nextButton, flexibleItem, title, flexibleItem, doneButton, nil];
        
        //toolBar = [[UIToolbar alloc]initWithFrame: CGRectMake(0, self.view.frame.size.height- myPickerView.frame.size.height-50, 320, 44)];
        [self setBarStyle:UIBarStyleDefault];
        [self setItems:toolbarItems];
        [self setTintColor:[UIColor whiteColor]];
        //[toolBar setBarTintColor:[UIColor colorWithRed:22.0/255.0 green:110.0/255.0 blue:209.0/255.0 alpha:1.0]];
        [self setBackgroundImage:[UIImage imageNamed:@"toolbar_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    return self;
}
-(void) next{
    [self.delegate toolbarNext];
    
}
-(void) previous{
    [self.delegate toolbarPrevious];
}
-(void) done{
    [self.delegate toolbarDone];
}
-(void)setTitle:(NSString *)text{
    toolbarTitle.text = text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
