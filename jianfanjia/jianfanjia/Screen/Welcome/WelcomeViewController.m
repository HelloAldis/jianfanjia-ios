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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btnWechatLogin;
@property (weak, nonatomic) IBOutlet UIImageView *wechatIcon;

@property (strong, nonatomic) NSMutableArray *imgViews;
@property (strong, nonatomic) NSArray *imgs;
@property (assign, nonatomic) NSInteger index;

@end

@implementation WelcomeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self reloadAllImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.btnWechatLogin.hidden = ![JYZSocialSnsConfigCenter isWXAppInstalled];
    self.wechatIcon.hidden = ![JYZSocialSnsConfigCenter isWXAppInstalled];
}

#pragma mark - UI
- (void)initUI {
    [self.btnWechatLogin setCornerRadius:5];
    [self.wechatIcon setTintColor:[UIColor whiteColor]];
    
    CGFloat height = kScreenHeight - 200;
    self.imgs = @[@"welcome_1", @"welcome_2", @"welcome_3", @"welcome_4"];
    self.imgViews = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, height)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        
        [self.scrollView addSubview:imgView];
        [self.imgViews addObject:imgView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth * 3, height)];
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    
    self.pageControl.numberOfPages = self.imgs.count;
}

#pragma mark - util
- (void)reloadAllImage {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    
    if (offsetX > kScreenWidth) { // 向右
        self.index++;
    } else if (offsetX < kScreenWidth) { // 向左
        self.index--;
    } else {
        
    }
    
    if (self.index < 0) {
        self.index = self.imgs.count - 1;
    } else if (self.index > self.imgs.count - 1) {
        self.index = 0;
    }
    
    NSString *preImg = self.imgs[self.index - 1 >= 0 ? self.index - 1 : self.imgs.count - 1];
    NSString *curImg = self.imgs[self.index];
    NSString *nextImg = self.imgs[self.index + 1 < self.imgs.count ? self.index + 1 : 0];
    
    UIImageView *preImgView = self.imgViews[0];
    UIImageView *centerImgView = self.imgViews[1];
    UIImageView *nextImgView = self.imgViews[2];
    
    preImgView.image = [UIImage imageNamed:preImg];
    centerImgView.image = [UIImage imageNamed:curImg];
    nextImgView.image = [UIImage imageNamed:nextImg];
    
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.pageControl.currentPage = self.index;
}

#pragma mark - scroll view deleaget
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.scrollView) {
        if (!decelerate) {
            [self reloadAllImage];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self reloadAllImage];
    }
}

#pragma mark - user actions
- (IBAction)onClickWeChat:(id)sender {
    [[LoginEngine shared] showWechatLogin:self completion:^(BOOL logined) {
        if (logined) {
            if ([DataManager shared].isWechatFirstLogin) {
                [ViewControllerContainer showCollectDecPhase];
            } else {
                UserGetInfo *getUser = [[UserGetInfo alloc] init];
                [API userGetInfo:getUser success:^{
                    [ViewControllerContainer showTab];
                } failure:^{
                } networkError:^{
                }];
            }
        }
    }];
}

- (IBAction)onClickLogin:(id)sender {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            [ViewControllerContainer showTab];
        }
    }];
}

- (IBAction)onClickExpierence:(id)sender {
    [ViewControllerContainer showTab];
}

@end
