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
#import "ViewControllerContainer.h"

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

@property (weak, nonatomic) RACDisposable *okDisposable;
@property (assign, nonatomic) BOOL wasRead;

@property (strong, nonatomic) UserNotification *notification;

@end

@implementation NotificationDetailViewController

+ (void)initialize {
    if ([self class] == [NotificationDetailViewController class]) {
        NotificationTitles = @{
                               kUserPNFromRescheduleRequest:@"改期",
                               kUserPNFromRescheduleAgree:@"改期",
                               kUserPNFromRescheduleReject:@"改期",
                               kUserPNFromPurchaseTip:@"采购",
                               kUserPNFromPayTip:@"付款",
                               kUserPNFromDBYSRequest:@"验收",
                               kUserPNFromSystemMsg:@"系统",
                               kUserPNFromOrderRespond:@"需求",
                               kUserPNFromOrderReject:@"需求",
                               kUserPNFromPlanSubmit:@"需求",
                               kUserPNFromAgreementConfigure:@"需求",
                               kUserPNFromMeasureHouseConfirm:@"需求",
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.wasRead) {
        [[NotificationDataManager shared] refreshUnreadCount];
        if (self.readBlock) {
            self.readBlock();
        }
    }
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"通知详情";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.notificationTitleBG setCornerRadius:self.notificationTitleBG.frame.size.height / 2];
    [self.btnOk setCornerRadius:self.btnOk.frame.size.height / 2];
    [self.btnAgree setCornerRadius:self.btnAgree.frame.size.height / 2];
    [self.btnReject setCornerRadius:self.btnReject.frame.size.height / 2];
    [self.btnReject setBorder:1 andColor:kThemeColor.CGColor];

    @weakify(self);
    self.okDisposable = [[self.btnOk rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickOk];
    }];
}

#pragma mark - load page
- (void)loadPage {
    // Javascript that disables pinch-to-zoom by inserting the HTML viewport meta tag into <head>
    NSString *source = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);\
    var body = document.getElementsByTagName('body')[0];\
    body.style.backgroundColor='#F0F0F0';";
    
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
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(64 + self.headerView.frame.size.height, 0, 50, 0);
    self.headerView.frame = CGRectMake(0, -self.headerView.frame.size.height, kScreenWidth, self.headerView.frame.size.height);
    [_webView.scrollView addSubview:self.headerView];
    _webView.scrollView.backgroundColor = self.headerView.backgroundColor;
    self.headerView.hidden = YES;
}

- (void)initData {
    self.lblNotificationTitle.text = NotificationTitles[self.notification.message_type];
    if ([NotificationBusiness contains:self.notification.message_type inFilter:[NotificationBusiness userRequirmentNotificationFilter]]) {
        self.lblCell.text = self.notification.requirement.basic_address;
        self.notificationTitleBG.backgroundColor = kExcutionStatusColor;
    } else if ([NotificationBusiness contains:self.notification.message_type inFilter:[NotificationBusiness userWorksiteNotificationFilter]]) {
        self.lblCell.text = self.notification.process.basic_address;
        self.notificationTitleBG.backgroundColor = kPassStatusColor;
    } else {
        self.lblCell.hidden = YES;
        self.notificationTitleBG.backgroundColor = kThemeColor;
    }

    self.lblSection.hidden = ![NotificationBusiness contains:self.notification.message_type inFilter:[NotificationBusiness userWorksiteNotificationFilter]];
    self.lblSection.text = [NSString stringWithFormat:@"%@阶段", [ProcessBusiness nameForKey:self.notification.section]];
    self.lblNotificationTime.text = [self.notification.create_at humDateString];
    self.headerView.hidden = NO;
    
    [self.webView loadHTMLString:self.notification.html baseURL:nil];
    [self initButtons];
}

- (void)initButtons {
    self.btnOk.hidden = YES;
    self.btnAgree.hidden = YES;
    self.btnReject.hidden = YES;
    
    if ([self.notification.message_type isEqualToString:kUserPNFromRescheduleRequest]) {
        [self handleReschedule];
    } else if ([self.notification.message_type isEqualToString:kUserPNFromPlanSubmit]) {
        [self handlePlanSubmit];
    } else if ([self.notification.message_type isEqualToString:kUserPNFromDBYSRequest]) {
        [self handleDBYSRequest];
    } else if ([self.notification.message_type isEqualToString:kUserPNFromMeasureHouseConfirm]) {
        [self handleMeasureHouseConfirm];
    } else if ([self.notification.message_type isEqualToString:kUserPNFromAgreementConfigure]) {
        [self handleAgreementConfigure];
    } else {
        [self displayDefaultOk];
    }
}

- (void)displayDefaultOk {
    self.btnOk.hidden = NO;
    [self.btnOk setTitle:@"朕，知道了" forState:UIControlStateNormal];
}

- (void)handleReschedule {
    Schedule *schedule = self.notification.schedule;
    if ([schedule.status isEqualToString:kSectionStatusChangeDateRequest]) {
        self.btnAgree.hidden = NO;
        self.btnReject.hidden = NO;
        [self.btnAgree addTarget:self action:@selector(agreeChangeDate) forControlEvents:UIControlEventTouchUpInside];
        [self.btnReject addTarget:self action:@selector(rejectChangeDate) forControlEvents:UIControlEventTouchUpInside];
    } else if ([schedule.status isEqualToString:kSectionStatusChangeDateAgree]
               && ![[GVUserDefaults standardUserDefaults].usertype isEqualToString:schedule.request_role]) {
        self.btnOk.hidden = NO;
        [self.btnOk disable:@"已同意"];
    } else if ([schedule.status isEqualToString:kSectionStatusChangeDateDecline]
               && ![[GVUserDefaults standardUserDefaults].usertype isEqualToString:schedule.request_role]) {
        self.btnOk.hidden = NO;
        [self.btnOk disable:@"已拒绝"];
    } else {
        [self displayDefaultOk];
    }
}

- (void)handlePlanSubmit {
    [self.okDisposable dispose];
    self.btnOk.hidden = NO;
    [self.btnOk setTitle:@"查看方案" forState:UIControlStateNormal];
    @weakify(self);
    self.okDisposable = [[self.btnOk rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [ViewControllerContainer showPlanPerview:self.notification.plan forRequirement:self.notification.requirement popTo:nil refresh:nil];
    }];
}

- (void)handleDBYSRequest {
    [self.okDisposable dispose];
    self.btnOk.hidden = NO;
    [self.btnOk setTitle:@"对比验收" forState:UIControlStateNormal];
    
    NSPredicate *sectionPre = [NSPredicate predicateWithFormat:@"SELF.name == %@", self.notification.section];
    NSArray *sections = [self.notification.process.sections filteredArrayUsingPredicate:sectionPre];
    if (sections.count > 0) {
        Section *section = [[Section alloc] initWith:sections[0]];
        section.ys = [[Ys alloc] initWith:[section.data objectForKey:@"ys"]];
        
        @weakify(self);
        self.okDisposable = [[self.btnOk rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [ViewControllerContainer showDBYS:section process:self.notification.processid popTo:nil refresh:nil];
        }];
    }
}

- (void)handleMeasureHouseConfirm {
    Plan *plan = self.notification.plan;
    if ([plan.status isEqualToString:kPlanStatusDesignerRespondedWithoutMeasureHouse]) {
        [self.okDisposable dispose];
        self.btnOk.hidden = NO;
        [self.btnOk setTitle:@"确认量房" forState:UIControlStateNormal];
        
        @weakify(self);
        self.okDisposable = [[self.btnOk rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self confirmMeasureHouse];
        }];
    } else if ([plan.status isEqualToString:kPlanStatusDesignerMeasureHouseWithoutPlan]) {
        self.btnOk.hidden = NO;
        [self.btnOk disable:@"已量房"];
    } else {
        [self displayDefaultOk];
    }
}

- (void)handleAgreementConfigure {
    [self.okDisposable dispose];
    self.btnOk.hidden = NO;
    [self.btnOk setTitle:@"查看合同" forState:UIControlStateNormal];
    @weakify(self);
    self.okDisposable = [[self.btnOk rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [ViewControllerContainer showAgreement:self.notification.requirement popTo:nil refresh:nil];
    }];
}

#pragma mark - api request
- (void)getNotificationDetail {
    [HUDUtil showWait];
    GetUserNotificationDetail *request = [[GetUserNotificationDetail alloc] init];
    request.messageid = self.notificationId;
    
    [API getUserNotificationDetail:request success:^{
        [HUDUtil hideWait];
        self.wasRead = YES;
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
    self.notification.schedule = [[Schedule alloc] initWith:self.notification.data[@"reschedule"]];
    self.notification.plan = [[Plan alloc] initWith:self.notification.data[@"plan"]];
}

#pragma mark - user action
- (void)onClickOk {
    [self clickBack];
}

- (void)agreeChangeDate {
    [HUDUtil showWait];
    AgreeReschedule *request = [[AgreeReschedule alloc] init];
    request.processid = self.notification.processid;

    [API agreeReschedule:request success:^{
        [HUDUtil hideWait];
        self.notification.schedule.status = kSectionStatusChangeDateAgree;
        [self initButtons];
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
        self.notification.schedule.status = kSectionStatusChangeDateDecline;
        [self initButtons];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
    }];
}

- (void)confirmMeasureHouse {
    ConfirmMeasuringHouse *request = [[ConfirmMeasuringHouse alloc] init];
    request.designerid = self.notification.designerid;
    request.requirementid = self.notification.requirement._id;
    
    [API confirmMeasuringHouse:request success:^{
        self.notification.plan.status = kPlanStatusDesignerMeasureHouseWithoutPlan;
        [self initButtons];
    } failure:^{
    } networkError:^{
    }];
}

@end
