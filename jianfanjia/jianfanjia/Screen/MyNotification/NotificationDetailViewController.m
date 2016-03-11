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
    
    
    NSString * htmlString = @"<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0'></head><body> Some html string \n <font size=\"13\" color=\"red\">This is some text!</font> <img src='http://dev.jianfanjia.com/api/v2/web/image/5683a76bcc55fab534b2fd64'></body></html>";
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
        self.notification = [[UserNotification alloc] initWith:[DataManager shared].data];
        [self initData];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
    }];
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
