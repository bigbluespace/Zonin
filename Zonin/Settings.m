//
//  Settings.m
//  Zonin
//
//  Created by Rezaul Karim on 16/8/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "Settings.h"
#import "RESideMenu.h"
#import "AdViewObject.h"

@interface Settings (){
    BOOL video;
}
@property (weak, nonatomic) IBOutlet UIButton *videoState;

@end

@implementation Settings{
     __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    video = YES;
    self.navigationController.navigationBarHidden = YES;
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (IBAction)videoBtn:(id)sender {
    if (video) {
        [_videoState setTitle:@"Video Off" forState:UIControlStateNormal];
        video = NO;
    }else{
        [_videoState setTitle:@"Video On" forState:UIControlStateNormal];
        video = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
