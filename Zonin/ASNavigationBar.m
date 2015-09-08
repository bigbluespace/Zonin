//
//  ASNavigationBar.m
//  Zonin
//
//  Created by Rezaul Karim on 15/8/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "ASNavigationBar.h"

@implementation ASNavigationBar
@synthesize backgroundImage = _backgroundImage;

-(void) setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage)
    {
        
        _backgroundImage = backgroundImage;
        [self setNeedsDisplay];
    }
}

-(void) drawRect:(CGRect)rect
{
    // This is how the custom BG image is actually drawn
    [self.backgroundImage drawInRect:rect];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    // This is how you set the custom size of your UINavigationBar
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGSize newSize = CGSizeMake(frame.size.width , self.backgroundImage.size.height);
    return newSize;
}
@end