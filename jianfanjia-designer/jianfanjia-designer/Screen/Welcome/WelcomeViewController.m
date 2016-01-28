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

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) W1View *w1;
@property (weak, nonatomic) W2View *w2;

@end

@implementation WelcomeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageControl.numberOfPages = 3;
    
    [self.btnSignup setCornerRadius:5];
    [self.btnSignup setBorder:1 andColor:[kThemeColor CGColor]];
    [self.btnLogin setCornerRadius:5];
    
    self.w1 = [W1View w1View];
    self.w2 = [W2View w2View];
    [self.scrollView addSubview:self.w1];
    [self.scrollView addSubview:self.w2];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth *2, kScreenHeight)];

     [GVUserDefaults standardUserDefaults].welcomeVersion  = kWelconeVersion;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.w1.frame = kScreenFullFrame;
    self.w2.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
}

#pragma mark - scroll view deleaget
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    NSInteger index = offsetX/kScreenWidth;
    self.pageControl.currentPage = index;
//    if (index == 1) {
//        self.pageControl.hidden = YES;
//        self.btnLogin.hidden = NO;
//        self.btnSignup.hidden = NO;
//    } else {
//        self.pageControl.hidden = NO;
//        self.btnSignup.hidden = YES;
//        self.btnLogin.hidden = YES;
//    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    if (offsetX >= kScreenWidth && velocity.x > 0) {
        [ViewControllerContainer showLogin];
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
