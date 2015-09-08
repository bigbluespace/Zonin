//
//  AddCrimeViewController.m
//  Zonin
//
//  Created by Arifuzzaman likhon on 6/23/15.
//  Copyright (c) 2015 UBITRIX. All rights reserved.
//

#import "AddCrimeViewController.h"
#import "RESideMenu.h"
#import "AdViewObject.h"

@interface AddCrimeViewController ()
{
    AddCrimeView*reportCrime;
    UIView*SpinnerView;
}
@property (weak, nonatomic) IBOutlet UIView *disclaimerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddCrimeViewController
{
    __weak IBOutlet UIView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;

     SpinnerView=[[UIView alloc]initWithFrame:self.containerView.bounds];
    reportCrime=[[AddCrimeView alloc]init];
//    NSArray*nibs=[[NSBundle mainBundle] loadNibNamed:@"addcrime"
//                                               owner:self options:nil];
//    reportCrime=[nibs objectAtIndex:0];
//    
//    [reportCrime setFrame:self.containerView.bounds];
//    [self.containerView addSubview:reportCrime];
    [self spinnerShow];
    AdViewObject *add = [AdViewObject sharedManager];
    [adView addSubview:add.adView];

}
//-------------------------
-(void)viewDidAppear:(BOOL)animated
{
    //reportCrime.CountryList=[Country getAllCountry];
    [self spinnerOff];
}
//--------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)agree:(id)sender {
    _disclaimerView.hidden = YES;
}
- (IBAction)disagree:(id)sender {
    _disclaimerView.hidden = YES;

}
- (IBAction)menuBtn:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//spinner function
//------------------------

-(void)spinnerShow
{
    
    [self.containerView addSubview:SpinnerView ];
    SpinnerView.backgroundColor=[UIColor clearColor];
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=SpinnerView.center;
    [SpinnerView addSubview:activityView];
    [activityView startAnimating];
    activityView.backgroundColor=[UIColor blueColor];
    [UIView animateWithDuration:0.2
                     animations:^{SpinnerView.alpha = 1.0;}
                     completion:nil];
}
//------------------------------------
-(void)spinnerOff
{
    [UIView animateWithDuration:0.8
                     animations:^{SpinnerView.alpha = 0.0;}
                     completion:^(BOOL finished){ [SpinnerView removeFromSuperview]; }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numbe:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 700;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
@end
