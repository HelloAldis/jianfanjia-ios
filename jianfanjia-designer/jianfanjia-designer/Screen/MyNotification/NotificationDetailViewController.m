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
#import "RejectUserAlertViewController.h"
#import "SetMeasureHouseTimeViewController.h"
#import "WebViewDelegateHandler.h"

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

@property (strong, nonatomic) DesignerNotification *notification;

@end

@implementation NotificationDetailViewController

+ (void)initialize {
    if ([self class] == [NotificationDetailViewController class]) {
        NotificationTitles = @{
                               kDesignerPNFromRescheduleRequest:@"改期",
                               kDesignerPNFromRescheduleAgree:@"改期",
                               kDesignerPNFromRescheduleReject:@"改期",
                               kDesignerPNFromPurchaseTip:@"采购",
                               kDesignerPNFromDBYSConfirm:@"验收",
                               kDesignerPNFromSystemMsg:@"系统",
                               kDesignerPNFromBasicInfoAuthPass:@"系统",
                               kDesignerPNFromBasicInfoAuthNotPass:@"系统",
                               kDesignerPNFromIDAuthPass:@"系统",
                               kDesignerPNFromIDAuthNotPass:@"系统",
                               kDesignerPNFromWorksiteAuthPass:@"系统",
                               kDesignerPNFromWorksiteAuthNotPass:@"系统",
                               kDesignerPNFromProductAuthPass:@"系统",
                               kDesignerPNFromProductAuthNotPass:@"系统",
                               kDesignerPNFromProductBreakRule:@"系统",
                               kDesignerPNFromOrderTip:@"需求",
                               kDesignerPNFromMeasureHouseConfirm:@"需求",
                               kDesignerPNFromPlanChoose:@"需求",
                               kDesignerPNFromPlanNotChoose:@"需求",
                               kDesignerPNFromAgreementConfirm:@"需求",
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
    _webView.navigationDelegate = self;
    [self.view insertSubview:_webView belowSubview:self.actionView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight + CGRectGetHeight(self.headerView.frame), 0, CGRectGetHeight(self.actionView.frame), 0);
    _webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, CGRectGetHeight(self.actionView.frame), 0);;
    self.headerView.frame = CGRectMake(0, -CGRectGetHeight(self.headerView.frame), kScreenWidth, CGRectGetHeight(self.headerView.frame));
    [_webView.scrollView addSubview:self.headerView];
    _webView.scrollView.backgroundColor = self.headerView.backgroundColor;
    self.headerView.hidden = YES;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [WebViewDelegateHandler shared].controller = self;
    [WebViewDelegateHandler webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
}

#pragma mark - Data

- (void)initData {
    self.lblNotificationTitle.text = NotificationTitles[self.notification.message_type];
    if ([NotificationBusiness contains:self.notification.message_type inFilter:[NotificationBusiness designerRequirmentNotificationFilter]]) {
        self.lblCell.text = self.notification.requirement.basic_address;
        self.notificationTitleBG.backgroundColor = kExcutionStatusColor;
    } else if ([NotificationBusiness contains:self.notification.message_type inFilter:[NotificationBusiness designerWorksiteNotificationFilter]]) {
        self.lblCell.text = self.notification.process.basic_address;
        self.notificationTitleBG.backgroundColor = kPassStatusColor;
    } else {
        self.lblCell.hidden = YES;
        self.notificationTitleBG.backgroundColor = kThemeColor;
    }

    self.lblSection.hidden = ![NotificationBusiness contains:self.notification.message_type inFilter:[NotificationBusiness designerWorksiteNotificationFilter]];
    self.lblSection.text = [NSString stringWithFormat:@"%@阶段", [self.notification.process sectionForName:self.notification.section].label];
    self.lblNotificationTime.text = [self.notification.create_at humDateString];
    self.headerView.hidden = NO;
    
    [self.webView loadHTMLString:self.notification.html baseURL:nil];
    [self initButtons];
}

- (void)initButtons {
    self.btnOk.hidden = YES;
    self.btnAgree.hidden = YES;
    self.btnReject.hidden = YES;
    
    if ([self.notification.message_type isEqualToString:kDesignerPNFromRescheduleRequest]) {
        [self handleReschedule];
    } else if ([self.notification.message_type isEqualToString:kDesignerPNFromPlanChoose]) {
        [self handlePlanChoose];
    } else if ([self.notification.message_type isEqualToString:kDesignerPNFromPlanNotChoose]) {
        [self handlePlanNotChoose];
    }  else if ([self.notification.message_type isEqualToString:kDesignerPNFromOrderTip]) {
        [self handleOrderTip];
    } else {
        [self displayDefaultOk];
    }
}

- (void)displayDefaultOk {
    self.btnOk.hidden = NO;
    [self.btnOk setNormTitle:@"朕，知道了"];
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

- (void)handlePlanChoose {
    [self.okDisposable dispose];
    self.btnOk.hidden = NO;
    [self.btnOk setNormTitle:@"查看方案"];
    @weakify(self);
    self.okDisposable = [[self.btnOk rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [ViewControllerContainer showPlanPerview:self.notification.plan forRequirement:self.notification.requirement popTo:nil refresh:nil];
    }];
}

- (void)handlePlanNotChoose {
    [self handlePlanChoose];
}

- (void)handleOrderTip {
    Plan *plan = self.notification.plan;
    [StatusBlock matchPlan:plan.status actions:
     @[[PlanHomeOwnerOrdered action:^{
            self.btnAgree.hidden = NO;
            self.btnReject.hidden = NO;
            [self.btnAgree setNormTitle:@"响应"];
            [self.btnReject setNormTitle:@"拒绝"];
            [self.btnAgree addTarget:self action:@selector(respondOrder) forControlEvents:UIControlEventTouchUpInside];
            [self.btnReject addTarget:self action:@selector(rejectOrder) forControlEvents:UIControlEventTouchUpInside];
            
            [self initViewRequirementItem];
        }],
       [PlanDesignerResponded action:^{
            self.btnOk.hidden = NO;
            [self.btnOk disable:@"已响应"];
        }],
       [PlanDesignerDeclined action:^{
            self.btnOk.hidden = NO;
            [self.btnOk disable:@"已拒绝"];
        }],
       [ElseStatus action:^{
            [self displayDefaultOk];
        }],
       ]];
}

#pragma mark - api request
- (void)getNotificationDetail {
    [HUDUtil showWait];
    GetDesignerNotificationDetail *request = [[GetDesignerNotificationDetail alloc] init];
    request.messageid = self.notificationId;
    
    [API getDesignerNotificationDetail:request success:^{
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
    self.notification = [[DesignerNotification alloc] initWith:[DataManager shared].data];
    self.notification.process = [[Process alloc] initWith:self.notification.data[@"process"]];
    self.notification.requirement = [[Requirement alloc] initWith:self.notification.data[@"requirement"]];
    self.notification.requirement.user = [[User alloc] initWith:self.notification.data[@"user"]];
    self.notification.schedule = [[Schedule alloc] initWith:self.notification.data[@"reschedule"]];
    self.notification.plan = [[Plan alloc] initWith:self.notification.data[@"plan"]];
}

#pragma mark - user action
- (void)onClickOk {
    [self clickBack];
}

#pragma mark - reschedule
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

#pragma mark - respond order
- (void)rejectOrder {
    @weakify(self);
    [RejectUserAlertViewController presentAlert:@"拒绝接单原因" msg:@"PS：以下收集的信息，将不会向业主展示，麻烦您耐心填写拒绝接单原因，以便我们合作更加紧密。" conform:^(NSString *reason) {
        @strongify(self);
        if (reason) {
            [HUDUtil showWait];
            DesignerRejectUser *request = [[DesignerRejectUser alloc] init];
            request.requirementid = self.notification.requirementid;
            request.reject_respond_msg = reason;
            [API designerRejectUser:request success:^{
                [HUDUtil hideWait];
                self.notification.plan.status = kPlanStatusDesignerDeclineHomeOwner;
                [self initButtons];
            } failure:^{
                [HUDUtil hideWait];
            } networkError:^{
                [HUDUtil hideWait];
            }];
        }
    }];
}

- (void)respondOrder {
    DesignerRespondUser *request = [[DesignerRespondUser alloc] init];
    request.requirementid = self.notification.requirementid;
    [API designerRespondUser:request success:nil failure:nil networkError:nil];
    
    @weakify(self);
    [SetMeasureHouseTimeViewController showSetMeasureHouseTime:self.notification.requirement completion:^(BOOL completion) {
        @strongify(self);
        if (completion) {
            self.notification.plan.status = kPlanStatusDesignerRespondedWithoutMeasureHouse;
            [self initButtons];
        }
    }];
}

#pragma mark - requirement
- (void)initViewRequirementItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看需求" style:UIBarButtonItemStylePlain target:self action:@selector(onClickViewRequirement)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)onClickViewRequirement {
    [ViewControllerContainer showRequirementCreate:self.notification.requirement];
}

@end
