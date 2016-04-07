//
//  ViewControllerContainer.m
//  AURA
//
//  Created by MacMiniS on 14-9-30.
//  Copyright (c) 2014年 AURA. All rights reserved.
//

#import "ViewControllerContainer.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "ProcessViewController.h"
#import "LeftViewController.h"
#import "TabViewController.h"
#import "MeViewController.h"
#import "RefreshViewController.h"
#import "VerifyPhoneViewController.h"
#import "SignupSuccessViewController.h"
#import "ResetPassViewController.h"
#import "EvaluateDesignerViewController.h"
#import "PlanListViewController.h"
#import "PlanPreviewViewController.h"
#import "PlanPriceDetailViewController.h"
#import "LeaveMessageViewController.h"
#import "DBYSViewController.h"
#import "RequirementCreateViewController.h"
#import "MyUserViewController.h"
#import "MyProcessViewController.h"
#import "CommentListViewController.h"
#import "MyNotificationViewController.h"
#import "NotificationDetailViewController.h"

@interface ViewControllerContainer ()

@property(weak, nonatomic) UIWindow *window;
@property(strong, nonatomic) UINavigationController *navTapMyUser;
@property(strong, nonatomic) UINavigationController *navTapMyProcess;
@property(strong, nonatomic) UINavigationController *navTapMy;

@property(strong, nonatomic) TabViewController *tab;

@end

static ViewControllerContainer *container;


@implementation ViewControllerContainer

+ (void)initialize {
    container = [[ViewControllerContainer alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.window = [AppDelegate sharedInstance].window;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kShowNotificationDetail object:nil];
    }
    
    return self;
}

- (void)receiveNotification:(NSNotification *)notification {
    Notification *noti = [[Notification alloc] initWith:(NSMutableDictionary *)notification.userInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([NotificationBusiness contains:noti.type inFilter:[NotificationBusiness designerAllNotificationsFilter]]) {
            [ViewControllerContainer showNotificationDetail:noti.messageid readBlock:nil];
        } else if ([NotificationBusiness contains:noti.type inFilter:[NotificationBusiness designerAllLeaveMsgFilter]]) {
            [ViewControllerContainer showMyComments];
        }
    });
}

+ (void)showAfterLanching {
    if ([GVUserDefaults standardUserDefaults].welcomeVersion < kWelcomeVersion) {
        //显示welcome
        WelcomeViewController *pages =[[WelcomeViewController alloc] initWithNibName:nil bundle:nil];
        container.window.rootViewController = pages;
    } else if ([GVUserDefaults standardUserDefaults].isLogin) {
        //显示首页
        [self showTab];
    } else {
        //显示登录
        [self showLogin];
    }
}

+ (void)showTab {
    container.tab = [[TabViewController alloc] initWithNibName:nil bundle:nil];
    MyUserViewController *myUser = [[MyUserViewController alloc] initWithNibName:nil bundle:nil];
    container.navTapMyUser = [[UINavigationController alloc] initWithRootViewController:myUser];
    container.navTapMyUser.hidesBottomBarWhenPushed = YES;
    NSDictionary * dict = [NSDictionary dictionaryWithObject:kThemeTextColor forKey: NSForegroundColorAttributeName];
    container.navTapMyUser.navigationBar.titleTextAttributes = dict;
    
    MyProcessViewController *myProcess = [[MyProcessViewController alloc] initWithNibName:nil bundle:nil];
    container.navTapMyProcess = [[UINavigationController alloc] initWithRootViewController:myProcess];
    container.navTapMyProcess.hidesBottomBarWhenPushed = YES;
    container.navTapMyProcess.navigationBar.titleTextAttributes = dict;
    
    MeViewController *me = [[MeViewController alloc] initWithNibName:nil bundle:nil];
    container.navTapMy = [[UINavigationController alloc] initWithRootViewController:me];
    container.navTapMy.hidesBottomBarWhenPushed = YES;
    container.navTapMy.navigationBar.titleTextAttributes = dict;
    
    container.tab.viewControllers = @[container.navTapMyUser, container.navTapMyProcess, container.navTapMy];
    container.window.rootViewController = container.tab;
}

+ (void)showLogin {
    container.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:
                                           [[LoginViewController alloc] initWithNibName:nil bundle:nil]];
}

+ (void)showSignup {
    LoginViewController *v = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    v.showSignup = YES;
    container.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:v];
}

+ (void)showVerifyPhone:(VerfityPhoneEvent)verfityPhoneEvent {
    VerifyPhoneViewController *v = [[VerifyPhoneViewController alloc] initWithEvent:verfityPhoneEvent];
    
    if (verfityPhoneEvent == VerfityPhoneEventBindPhone) {
        [((id)container.tab.selectedViewController.presentedViewController) pushViewController:v animated:YES];
    } else {
        UINavigationController *nav =  (UINavigationController *)container.window.rootViewController;
        [nav pushViewController:v animated:YES];
    }
}

+ (void)showResetPass {
    ResetPassViewController *v = [[ResetPassViewController alloc] init];
    UINavigationController *nav =  (UINavigationController *)container.window.rootViewController;
    [nav pushViewController:v animated:YES];
}

+ (void)showProcessPreview {
    ProcessViewController *v = [[ProcessViewController alloc] initWithProcessPreview];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showProcess:(NSString *)processid {
    ProcessViewController *v = [[ProcessViewController alloc] initWithProcess:processid];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showRequirementCreate:(Requirement *)requirement {
    //no reqirement create
    if (requirement) {
        RequirementCreateViewController *v = [[RequirementCreateViewController alloc] initToViewRequirement:requirement];
        [container.tab.selectedViewController pushViewController:v animated:YES];
    } else {
        RequirementCreateViewController *v = [[RequirementCreateViewController alloc] initToCreateRequirement];
        [container.tab.selectedViewController pushViewController:v animated:YES];
    }
}

+ (void)showPlanList:(Requirement *)requirement {
    PlanListViewController *v = [[PlanListViewController alloc] initWithRequirement:requirement];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)leaveMessage:(Plan *)plan {
    LeaveMessageViewController *v = [[LeaveMessageViewController alloc] initWithPlan:plan];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)leaveMessage:(Process *)process section:(NSString *)section item:(NSString *)item block:(void(^)(void))RefreshBlock {
    LeaveMessageViewController *v = [[LeaveMessageViewController alloc] initWithProcess:process section:section item:item block:RefreshBlock];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showPlanPerview:(Plan *)plan forRequirement:(Requirement *)requirement popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock {
    PlanPreviewViewController *v = [[PlanPreviewViewController alloc] initWithPlan:plan forRequirement:requirement popTo:popTo refresh:refreshBlock];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showPlanPriceDetail:(Plan *)plan requirement:(Requirement *)requirement {
    PlanPriceDetailViewController *v = [[PlanPriceDetailViewController alloc] initWithPlan:plan requirement:requirement];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showEvaluate:(Designer *)designer evaluation:(Evaluation *)evaluation {
    EvaluateDesignerViewController *v = [[EvaluateDesignerViewController alloc] initWithDesigner:designer evaluation:evaluation];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showDBYS:(Section *)section process:(NSString *)processid refresh:(void(^)(void))refreshBlock {
    DBYSViewController *v = [[DBYSViewController alloc] initWithSection:section process:processid refresh:refreshBlock];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showMyNotification {
    MyNotificationViewController *v = [[MyNotificationViewController alloc] init];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showNotificationDetail:(NSString *)notificationid readBlock:(NotificationReadBlock)readBlock {
    NotificationDetailViewController *v = [[NotificationDetailViewController alloc] init];
    v.notificationId = notificationid;
    v.readBlock = readBlock;
    [container.tab.selectedViewController pushViewController:v animated:YES];
}


+ (void)showMyComments {
    //if has designer order screen pop to
    UINavigationController* nav =  container.tab.selectedViewController;
    for (UIViewController *v in nav.viewControllers) {
        if ([v isKindOfClass:[CommentListViewController class]]) {
            [nav popToViewController:v animated:YES];
            return;
        }
    }
    
    CommentListViewController *v = [[CommentListViewController alloc] init];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showRefresh {
    RefreshViewController *refresh = [[RefreshViewController alloc] initWithNibName:nil bundle:nil];

    [UIView transitionWithView:container.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        container.window.rootViewController = refresh;
                    }
                    completion:nil];
}

+ (void)showOfflineImages:(NSArray *)offlineImages index:(NSInteger)index {
    ImageDetailViewController *imgDetail = [[ImageDetailViewController alloc] initWithOffline:offlineImages index:index];
    imgDetail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[ViewControllerContainer getCurrentTapController] presentViewController:imgDetail animated:YES completion:nil];
}

+ (void)showOnlineImages:(NSArray *)onlineImages index:(NSInteger)index {
    ImageDetailViewController *imgDetail = [[ImageDetailViewController alloc] initWithOnline:onlineImages index:index];
    imgDetail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[ViewControllerContainer getCurrentTapController] presentViewController:imgDetail animated:YES completion:nil];
}

+ (void)refreshSuccess {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView transitionWithView:container.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            container.window.rootViewController = container.tab;
                        }
                        completion:nil];
    });
}

+ (UIViewController *)getCurrentTapController {
    return ((UINavigationController *)container.tab.selectedViewController).topViewController;
}

+ (void)logout {
    [GeTuiSdk unbindAlias:[GVUserDefaults standardUserDefaults].userid];
    container.tab = nil;
    container.navTapMyUser = nil;
    container.navTapMyProcess = nil;
    container.navTapMy = nil;
    [GVUserDefaults standardUserDefaults].isLogin = NO;
    [GVUserDefaults standardUserDefaults].phone = nil;
    [GVUserDefaults standardUserDefaults].usertype = nil;
    [GVUserDefaults standardUserDefaults].userid = nil;
    [GVUserDefaults standardUserDefaults].imageid = nil;
    [GVUserDefaults standardUserDefaults].username = nil;
    [GVUserDefaults standardUserDefaults].loginDate = nil;
    [GVUserDefaults standardUserDefaults].sex = nil;
    [GVUserDefaults standardUserDefaults].province = nil;
    [GVUserDefaults standardUserDefaults].city = nil;
    [GVUserDefaults standardUserDefaults].district = nil;
    [GVUserDefaults standardUserDefaults].address = nil;
    [GVUserDefaults standardUserDefaults].wechat_openid = nil;
    [GVUserDefaults standardUserDefaults].wechat_unionid = nil;
    
    [ViewControllerContainer showLogin];
}

@end
