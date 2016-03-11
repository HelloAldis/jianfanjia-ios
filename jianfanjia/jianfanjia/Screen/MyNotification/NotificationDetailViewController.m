//
//  NotificationDetailViewController.m
//  jianfanjia
//
//  Created by Karos on 16/3/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "NotificationDetailViewController.h"
#import "MyNotificationDataManager.h"

static NSDictionary *NotificationTitles = nil;

@interface NotificationDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *notificationTitleBG;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblSection;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationTime;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblBottom;

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionViewHeightConst;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNotificationDetail];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"通知详情";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    [self.notificationTitleBG setCornerRadius:8];
    [self.btnOk setCornerRadius:8];
    [self.btnAgree setCornerRadius:8];
    [self.btnReject setCornerRadius:8];
    [self.btnReject setBorder:1 andColor:kThemeColor.CGColor];
    [self.lblContent setRowSpace:10];
    [self.lblBottom setRowSpace:10];
    
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
    
    [self initData];
}

- (void)initData {
    self.lblCell.text = self.notification.cell;
    self.lblSection.hidden = ![[NotificationBusiness userWorksiteNotificationFilter] containsObject:self.notification.message_type];
    self.lblSection.text = [NSString stringWithFormat:@"%@阶段", [ProcessBusiness nameForKey:self.notification.section]];
    self.lblNotificationTime.text = [self.notification.create_at humDateString];
    self.lblContent.text = self.notification.content;
    
    
    NSString * htmlString = @"<html><body>\
    <font size=\"4\" color=\"#7c8389\">\
    <p>尊敬的业主您好：</p >\
    <p>您的设计师戴涛希望将本阶段工期修改至</p >\
    <p><font size=\"5\" color=\"#fe7003\">2016-04-01</font></p >\
    <p>等待您的确认！如有问题请及时与设计师联系。</p >\
    <p>也可以拨打我们的客服热线：<a href='tel://18107218595'>400-8515-167</a></p >\
    </font>\
    </body></html>";
    [self.lblBottom setHtml:htmlString]; 
    
    [self initButtons];
}

- (void)initButtons {
//    self.actionView.hidden = ![self.notification.status isEqualToString:kNotificationUnread];
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
