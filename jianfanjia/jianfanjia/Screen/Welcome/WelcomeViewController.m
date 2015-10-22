//
//  WelcomeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/8.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ViewControllerContainer.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnSignup setCornerRadius:5];
    [self.btnSignup setBorder:1 andColor:[[UIColor whiteColor] CGColor]];
    [self.btnLogin setCornerRadius:5];
    
    UIImageView *w1 = [[UIImageView alloc] initWithFrame:kScreenFullFrame];
    [w1 setContentMode:UIViewContentModeScaleAspectFill];
    w1.image = [UIImage imageNamed:@"welcome_1"];
     UIImageView *w2 = [[UIImageView alloc] initWithFrame:kScreenFullFrame];
    [w2 setContentMode:UIViewContentModeScaleAspectFill];
    w2.image = [UIImage imageNamed:@"welcome_2"];
    w2.frame = CGRectOffset(w2.frame, kScreenWidth, 0);
    UIImageView *w3 = [[UIImageView alloc] initWithFrame:kScreenFullFrame];
    [w3 setContentMode:UIViewContentModeScaleAspectFill];
    w3.image = [UIImage imageNamed:@"welcome_3"];
    w3.frame = CGRectOffset(w3.frame, kScreenWidth*2, 0);
    UIImageView *w4 = [[UIImageView alloc] initWithFrame:kScreenFullFrame];
    [w4 setContentMode:UIViewContentModeScaleAspectFill];
    w4.image = [UIImage imageNamed:@"welcome_4"];
    w4.frame = CGRectOffset(w4.frame, kScreenWidth*3, 0);
    
    [self.scrollView addSubview:w1];
    [self.scrollView addSubview:w2];
    [self.scrollView addSubview:w3];
    [self.scrollView addSubview:w4];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth *4, kScreenHeight)];
    
    [GVUserDefaults standardUserDefaults].welcomeVersion  = kWelconeVersion;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = self.scrollView.contentOffset.x/kScreenWidth;
    self.pageControl.currentPage = index;
    if (index == 3) {
        self.pageControl.hidden = YES;
        self.btnLogin.hidden = NO;
        self.btnSignup.hidden = NO;
    } else {
        self.pageControl.hidden = NO;
        self.btnSignup.hidden = YES;
        self.btnLogin.hidden = YES;
    }
}

- (IBAction)onClickLogin:(id)sender {
    [ViewControllerContainer showLogin];
}

- (IBAction)onClickSignup:(id)sender {
    
}

@end
