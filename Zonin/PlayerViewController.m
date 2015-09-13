//
//  PlayerViewController.m
//  Zonin
//
//  Created by Admin on 14/09/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "PlayerViewController.h"
#import "rootViewViewController.h"

@interface PlayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *playerView;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"videostart" ofType:@"mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    
    
    self.moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
    [self.moviePlayer.view setFrame:self.view.frame];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer setShouldAutoplay:NO];
    self.moviePlayer.controlStyle = NO;
    [_playerView addSubview:self.moviePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    [self.moviePlayer play];
    
    
}
- (IBAction)skipBtnAction:(id)sender {
    [self.moviePlayer stop];
    [self goProject];
}

-(void)playBackFinished:(NSNotification*)notification{
    [self goProject];
}
-(void)goProject{
    
    rootViewViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:root];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
