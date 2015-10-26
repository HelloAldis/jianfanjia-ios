//
//  WelcomeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/8.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ViewControllerContainer.h"
#import "W1View.h"
#import "W2View.h"
#import "W3View.h"
#import "W4View.h"

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
    
    UIView *w1 = [W1View w1View];
    w1.frame = kScreenFullFrame;
    
    UIView *w2 = [W2View w2View];
    w2.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    
    UIView *w3 = [W3View w3View];
    w3.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight);
    
    UIView *w4 = [W4View w4View];
    w4.frame = CGRectMake(kScreenWidth*3, 0, kScreenWidth, kScreenHeight);
    
    
    DDLogDebug(@"%@", NSStringFromCGRect(w2.frame));
    [self.scrollView addSubview:w1];
    [self.scrollView addSubview:w2];
    [self.scrollView addSubview:w3];
    [self.scrollView addSubview:w4];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth *4, kScreenHeight)];
    
//    [GVUserDefaults standardUserDefaults].welcomeVersion  = kWelconeVersion;
        DDLogDebug(@"%@", NSStringFromCGRect(w2.frame));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (UIView *v in self.scrollView.subviews) {
        DDLogDebug(@"%@", v);
    }
    
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
