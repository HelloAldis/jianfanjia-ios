//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MeViewController.h"
#import "SettingViewController.h"
#import "UserInfoViewController.h"
#import "ViewControllerContainer.h"
#import "MyFavoriateViewController.h"
#import "CustomerServiceViewController.h"
#import "FeedbackViewController.h"

@interface MeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userThumnail;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblCache;

@property (weak, nonatomic) IBOutlet UIButton *btnMyNotification;
@property (weak, nonatomic) IBOutlet UIButton *btnMyLeaveMsg;

@property (assign, nonatomic) CGRect originUserImageFrame;
@property (assign, nonatomic) CGRect originAvatarImageFrame;
@property (assign, nonatomic) BOOL isTabbarhide;

@end

@implementation MeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    [self.userThumnail setCornerRadius:self.userThumnail.frame.size.width / 2];
    [self.userThumnail setBorder:1 andColor:[[UIColor whiteColor] CGColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self updateCache];
    [self updateUnreadNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initUIData];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (CGRectGetHeight(self.originUserImageFrame) == 0) {
        self.originUserImageFrame = self.userImageView.frame;
    }
    
    if (self.isTabbarhide) {
        [self showTabbar];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!self.isTabbarhide && self.navigationController.viewControllers.count > 1) {
        [self hideTabbar];
    }
}

#pragma mark - UI
- (void)initUIData {
    self.lblUsername.text = [GVUserDefaults standardUserDefaults].username;
    if ([GVUserDefaults standardUserDefaults].phone) {
        self.lblPhone.text = [NSString stringWithFormat:@"帐号：%@", [GVUserDefaults standardUserDefaults].phone];
    } else {
        self.lblPhone.hidden = YES;
    }
    
    [self.userThumnail setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
    [[NotificationDataManager shared] refreshUnreadCount];
}

- (void)updateUnreadNumber {
    [[NotificationDataManager shared] subscribeMyNotificationUnreadCount:^(NSInteger count) {
        self.btnMyNotification.shouldHideBadgeAtZero = YES;
        self.btnMyNotification.badgeNumber = [@(count) stringValue];
    }];
    
    [[NotificationDataManager shared] subscribeMyLeaveMsgUnreadCount:^(NSInteger count) {
        self.btnMyLeaveMsg.shouldHideBadgeAtZero = YES;
        self.btnMyLeaveMsg.badgeNumber = [@(count) stringValue];
    }];
}

#pragma mark - user action
- (IBAction)onTapUserImageView:(id)sender {
    UserInfoViewController *v = [[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:v animated:YES];
}

- (IBAction)onClickNotification:(id)sender {
    [ViewControllerContainer showMyNotification];
}

- (IBAction)onClickFavoriate:(id)sender {
    MyFavoriateViewController *v = [[MyFavoriateViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:v animated:YES];
}

- (IBAction)onClickComment:(id)sender {
    [ViewControllerContainer showMyComments];
}

- (IBAction)onClickAcountBind:(id)sender {
    [ViewControllerContainer showAccountBind];
}

- (IBAction)onClickClearCache:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清空缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //Do nothing
    }];
    
    @weakify(self)
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        [cache.memoryCache removeAllObjects];
        [cache.diskCache removeAllObjects];
        [self updateCache];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onClickSuggestion:(id)sender {
    FeedbackViewController *v = [[FeedbackViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:v animated:YES];
}

- (IBAction)onClickOnlineService:(id)sender {
    [self.navigationController pushViewController:[CustomerServiceViewController instance] animated:YES];
}

- (IBAction)onClickMore:(id)sender {
    SettingViewController *v = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (IBAction)onClickPhoneConsult:(id)sender {
    [PhoneUtil call:@"4008515167"];
}

#pragma mark - scroll view  delegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect f = CGRectZero;
    f.origin.y = offsetY;
    f.size.width = MAX(kScreenWidth, kScreenWidth - offsetY);
    f.size.height =  CGRectGetHeight(self.originUserImageFrame) - offsetY;
    f.origin.x = MIN(0, offsetY / 2);
    self.userImageView.frame = f;
}

#pragma mark - Util
- (void)hideTabbar {
    if (!self.isTabbarhide) {
        self.isTabbarhide = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight, CGRectGetWidth(self.tabBarController.tabBar.frame), CGRectGetHeight(self.tabBarController.tabBar.frame));
        }];
    }
}

- (void)showTabbar {
    if (self.isTabbarhide) {
        self.isTabbarhide = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight - CGRectGetHeight(self.tabBarController.tabBar.frame), CGRectGetWidth(self.tabBarController.tabBar.frame), CGRectGetHeight(self.tabBarController.tabBar.frame));
        }];
    }
}

- (void)updateCache {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    self.lblCache.text = [@((cache.memoryCache.totalCost + cache.diskCache.totalCost) / 8) humSizeString];
}

@end
