//
//  NotificationDetailViewController.m
//  jianfanjia
//
//  Created by Karos on 16/3/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "NotificationDetailViewController.h"
#import <SafariServices/SafariServices.h>
#import <Foundation/Foundation.h>

@import WebKit;

static NSDictionary *NotificationTitles = nil;

@interface NotificationDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *notificationTitleBG;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblSection;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationTime;

@property (strong, nonatomic) WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *actionView;

@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;

@property (strong, nonatomic) UserNotification *notification;

@end

@implementation NotificationDetailViewController

+ (void)initialize {
    if ([self class] == [NotificationDetailViewController class]) {
        NotificationTitles = @{kUserPNFromPayTip:@"付款提醒",
                               kUserPNFromPurchaseTip:@"采购提醒",
                               kUserPNFromRescheduleAgree:@"改期提醒",
                               kUserPNFromRescheduleReject:@"改期提醒",
                               kUserPNFromRescheduleRequest:@"改期提醒",
                               kUserPNFromDBYSRequest:@"验收提醒",
                               };
    }
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self loadPage];
    [self getNotificationDetail];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"通知详情";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.notificationTitleBG setCornerRadius:8];
    [self.btnOk setCornerRadius:8];
    [self.btnAgree setCornerRadius:8];
    [self.btnReject setCornerRadius:8];
    [self.btnReject setBorder:1 andColor:kThemeColor.CGColor];
    
    @weakify(self);
    [[self.btnOk rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickOk];
    }];
    
    [[self.btnAgree rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self agreeChangeDate];
    }];

    [[self.btnReject rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self rejectChangeDate];
    }];
}

#pragma mark - load page
- (void)loadPage {
    // Javascript that disables pinch-to-zoom by inserting the HTML viewport meta tag into <head>
    NSString *source = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);";
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *userContentController = [WKUserContentController new];
    [userContentController addUserScript:script];
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.userContentController = userContentController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    _webView.allowsBackForwardNavigationGestures = YES;
    [self.view insertSubview:_webView belowSubview:self.actionView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(164, 0, 50, 0);
    self.headerView.frame = CGRectMake(0, -100, kScreenWidth, 100);
    [_webView.scrollView addSubview:self.headerView];
    _webView.scrollView.backgroundColor = self.headerView.backgroundColor;
    self.headerView.hidden = YES;
}

- (void)initData {
    if ([[NotificationBusiness userRequirmentNotificationFilter] containsObject:self.notification.message_type]) {
        self.lblCell.text = self.notification.requirement.cell;
    } else if ([[NotificationBusiness userWorksiteNotificationFilter] containsObject:self.notification.message_type]) {
        self.lblCell.text = self.notification.process.cell;
    } else {
        self.lblCell.hidden = YES;
    }

    self.lblSection.hidden = ![[NotificationBusiness userWorksiteNotificationFilter] containsObject:self.notification.message_type];
    self.lblSection.text = [NSString stringWithFormat:@"%@阶段", [ProcessBusiness nameForKey:self.notification.section]];
    self.lblNotificationTime.text = [self.notification.create_at humDateString];
    self.headerView.hidden = NO;
    
    [self.webView loadHTMLString:self.notification.html baseURL:nil];
    [self initButtons];
}

- (void)initButtons {
//    self.actionViewHeightConst.constant = [self.notification.status isEqualToString:kNotificationUnread] ? : 0;
//    
    if ([self.notification.message_type isEqualToString:kUserPNFromRescheduleRequest]) {
        self.btnAgree.hidden = NO;
        self.btnReject.hidden = NO;
        self.btnOk.hidden = YES;
    } else {
        self.btnAgree.hidden = YES;
        self.btnReject.hidden = YES;
        self.btnOk.hidden = NO;
    }
}

#pragma mark - api request
- (void)getNotificationDetail {
    [HUDUtil showWait];
    GetUserNotificationDetail *request = [[GetUserNotificationDetail alloc] init];
    request.messageid = self.notificationId;
    
    [API getUserNotificationDetail:request success:^{
        [HUDUtil hideWait];
        [NotificationBusiness reduceOneBadge];
        [self initNotification];
        [self initData];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
    }];
}

- (void)initNotification {
    self.notification = [[UserNotification alloc] initWith:[DataManager shared].data];
    self.notification.process = [[Process alloc] initWith:self.notification.data[@"process"]];
    self.notification.requirement = [[Requirement alloc] initWith:self.notification.data[@"requirement"]];
    self.notification.reschedule = [[Reschedule alloc] initWith:self.notification.data[@"reschedule"]];
}

#pragma mark - user action
- (void)onClickOk {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)agreeChangeDate {
    [HUDUtil showWait];
    AgreeReschedule *request = [[AgreeReschedule alloc] init];
    request.processid = self.notification.processid;

    [API agreeReschedule:request success:^{
        [HUDUtil hideWait];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
    }];
}

- (void)rejectChangeDate {
    [HUDUtil showWait];
    RejectReschedule *request = [[RejectReschedule alloc] init];
    request.processid = self.notification.processid;

    [API rejectReschedule:request success:^{
        [HUDUtil hideWait];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
    }];
}

@end
