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

@property (weak, nonatomic) W1View *w1;
@property (weak, nonatomic) W2View *w2;
@property (weak, nonatomic) W3View *w3;
@property (weak, nonatomic) W4View *w4;
@end

@implementation WelcomeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnSignup setCornerRadius:5];
    [self.btnSignup setBorder:1 andColor:[[UIColor whiteColor] CGColor]];
    [self.btnLogin setCornerRadius:5];
    
    self.w1 = [W1View w1View];
    self.w2 = [W2View w2View];
    self.w3 = [W3View w3View];
    self.w4 = [W4View w4View];
    [self.scrollView addSubview:self.w1];
    [self.scrollView addSubview:self.w2];
    [self.scrollView addSubview:self.w3];
    [self.scrollView addSubview:self.w4];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth *4, kScreenHeight)];
    
    [GVUserDefaults standardUserDefaults].welcomeVersion  = kWelconeVersion;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.w1.frame = kScreenFullFrame;
    self.w2.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    self.w3.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight);
    self.w4.frame = CGRectMake(kScreenWidth*3, 0, kScreenWidth, kScreenHeight);
}

#pragma mark - UI


#pragma mark - scroll view deleaget
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

#pragma mark - user actions
- (IBAction)onClickLogin:(id)sender {
    [ViewControllerContainer showLogin];
}

- (IBAction)onClickSignup:(id)sender {
    [ViewControllerContainer showSignup];
}

@end
