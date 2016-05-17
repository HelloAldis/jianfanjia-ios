//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MeViewController.h"
#import "SettingViewController.h"
#import "FeedbackViewController.h"
#import "ViewControllerContainer.h"
#import "CustomerServiceViewController.h"

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

@end


@implementation MeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTransparentNavBar:UIBarStyleDefault];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    [self.userThumnail setCornerRadius:self.userThumnail.frame.size.width / 2];
    [self.userThumnail setBorder:1 andColor:[[UIColor whiteColor] CGColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self updateCache];
    [self updateUnreadNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initUIData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (CGRectGetHeight(self.originUserImageFrame) == 0) {
        self.originUserImageFrame = self.userImageView.frame;
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
- (IBAction)onClickNotification:(id)sender {
    [ViewControllerContainer showMyNotification:NotificationTypeAll];
}

- (IBAction)onClickComment:(id)sender {
    [ViewControllerContainer showMyComments];
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
    [[ViewControllerContainer navigation] pushViewController:v animated:YES];
}

- (IBAction)onClickOnlineService:(id)sender {
    [[ViewControllerContainer navigation] pushViewController:[CustomerServiceViewController instance] animated:YES];
}

- (IBAction)onClickMore:(id)sender {
    SettingViewController *v = [[SettingViewController alloc] init];
    [[ViewControllerContainer navigation] pushViewController:v animated:YES];
}

- (IBAction)onClickPhoneConsult:(id)sender {
    [PhoneUtil call:kConsultPhone];
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

- (void)updateCache {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    self.lblCache.text = [@((cache.memoryCache.totalCost + cache.diskCache.totalCost) / 8) humSizeString];
}

@end
