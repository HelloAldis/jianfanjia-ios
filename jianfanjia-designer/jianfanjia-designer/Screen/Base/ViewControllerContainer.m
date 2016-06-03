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
#import "MeViewController.h"
#import "RefreshViewController.h"
#import "VerifyPhoneViewController.h"
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
#import "DesignerAuthViewController.h"
#import "InfoAuthViewController.h"
#import "ProductAuthViewController.h"
#import "ProductAuthUploadPart1ViewController.h"
#import "ProductAuthUploadPart2ViewController.h"
#import "ProductViewController.h"
#import "TeamAuthViewController.h"
#import "IDAuthViewController.h"
#import "TeamAuthUpdateViewController.h"
#import "ServiceAreaViewController.h"
#import "EmailAuthRequestViewController.h"
#import "EmailAuthReviewingViewController.h"
#import "EmailAuthSuccessViewController.h"
#import "WebViewWithActionController.h"
#import "TeamConfigureViewController.h"

@interface ViewControllerContainer ()

@property(weak, nonatomic) UIWindow *window;
@property(strong, nonatomic) UINavigationController *navigation;

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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([NotificationBusiness contains:noti.type inFilter:[NotificationBusiness designerAllNotificationsFilter]]) {
            [ViewControllerContainer showNotificationDetail:noti.messageid readBlock:nil];
        } else if ([NotificationBusiness contains:noti.type inFilter:[NotificationBusiness designerAllLeaveMsgFilter]]) {
            [ViewControllerContainer showMyComments];
        }
    });
}

+ (UINavigationController *)navigation {
    return container.navigation;
}

+ (TabViewController *)tab {
    return container.tab;
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
    container.tab.automaticallyAdjustsScrollViewInsets = NO;
    
    MyUserViewController *myUser = [[MyUserViewController alloc] initWithNibName:nil bundle:nil];
    MyProcessViewController *myProcess = [[MyProcessViewController alloc] initWithNibName:nil bundle:nil];
    MeViewController *me = [[MeViewController alloc] initWithNibName:nil bundle:nil];
    
    container.tab.tapMyUser = [[UINavigationController alloc] initWithRootViewController:myUser];
    container.tab.tapMyProcess = [[UINavigationController alloc] initWithRootViewController:myProcess];
    container.tab.tapMy = [[UINavigationController alloc] initWithRootViewController:me];
    
    container.tab.viewControllers = @[container.tab.tapMyUser, container.tab.tapMyProcess, container.tab.tapMy];
    container.navigation = [[UINavigationController alloc] initWithRootViewController:container.tab];
    container.window.rootViewController = container.navigation;
    
    if (![DesignerBusiness isDesignerFinishFundationAuth]) {
        [container.tab setSelectedViewController:container.tab.tapMy];
    }
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
    
    UINavigationController *nav =  (UINavigationController *)container.window.rootViewController;
    [nav pushViewController:v animated:YES];
}

+ (void)showResetPass {
    ResetPassViewController *v = [[ResetPassViewController alloc] init];
    UINavigationController *nav =  (UINavigationController *)container.window.rootViewController;
    [nav pushViewController:v animated:YES];
}

+ (void)showProcessPreview {
    ProcessViewController *v = [[ProcessViewController alloc] initWithProcessPreview];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showProcess:(NSString *)processid {
    ProcessViewController *v = [[ProcessViewController alloc] initWithProcess:processid];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showProduct:(NSString *)productid {
    [self showProduct:productid isModal:NO];
}

+ (void)showProduct:(NSString *)productid isModal:(BOOL)isModal {
    UIViewController *presented = container.navigation.presentedViewController;
    UINavigationController *nav = presented ? (UINavigationController *)presented : container.navigation;
    BOOL hasProduct = NO;
    for (UIViewController *v in nav.viewControllers) {
        if ([v isKindOfClass:[ProductViewController class]]) {
            hasProduct = YES;
            ProductViewController *p = (ProductViewController *)v;
            if (![p.productid isEqualToString:productid]) {
                p.productid = productid;
                p.needRefreshProductViewController = YES;
            }
            [nav popToViewController:v animated:YES];
        }
    }
    
    if (!hasProduct) {
        ProductViewController *v = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
        v.productid = productid;
        
        if (isModal) {
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:v];
            v.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            v.modalPresentationStyle = UIModalPresentationOverFullScreen;
            
            [nav presentViewController:navi animated:YES completion:nil];
        } else {
            [nav pushViewController:v animated:YES];
        }
    }
}

+ (void)showRequirementCreate:(Requirement *)requirement {
    //no reqirement create
    if (requirement) {
        RequirementCreateViewController *v = [[RequirementCreateViewController alloc] initToViewRequirement:requirement];
        [container.navigation pushViewController:v animated:YES];
    } else {
        RequirementCreateViewController *v = [[RequirementCreateViewController alloc] initToCreateRequirement];
        [container.navigation pushViewController:v animated:YES];
    }
}

+ (void)showPlanList:(Requirement *)requirement {
    PlanListViewController *v = [[PlanListViewController alloc] initWithRequirement:requirement];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)leaveMessage:(Plan *)plan {
    LeaveMessageViewController *v = [[LeaveMessageViewController alloc] initWithPlan:plan];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)leaveMessage:(Process *)process section:(NSString *)section item:(NSString *)item block:(void(^)(void))RefreshBlock {
    LeaveMessageViewController *v = [[LeaveMessageViewController alloc] initWithProcess:process section:section item:item block:RefreshBlock];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showPlanPerview:(Plan *)plan forRequirement:(Requirement *)requirement popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock {
    PlanPreviewViewController *v = [[PlanPreviewViewController alloc] initWithPlan:plan forRequirement:requirement popTo:popTo refresh:refreshBlock];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showPlanPriceDetail:(Plan *)plan requirement:(Requirement *)requirement {
    PlanPriceDetailViewController *v = [[PlanPriceDetailViewController alloc] initWithPlan:plan requirement:requirement];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showEvaluate:(Designer *)designer evaluation:(Evaluation *)evaluation {
    EvaluateDesignerViewController *v = [[EvaluateDesignerViewController alloc] initWithDesigner:designer evaluation:evaluation];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showDBYS:(Section *)section process:(NSString *)processid refresh:(void(^)(void))refreshBlock {
    DBYSViewController *v = [[DBYSViewController alloc] initWithSection:section process:processid refresh:refreshBlock];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showMyNotification:(NotificationType)displayType {
    MyNotificationViewController *v = [[MyNotificationViewController alloc] init];
    v.displayType = displayType;
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showNotificationDetail:(NSString *)notificationid readBlock:(NotificationReadBlock)readBlock {
    NotificationDetailViewController *v = [[NotificationDetailViewController alloc] init];
    v.notificationId = notificationid;
    v.readBlock = readBlock;
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showMyComments {
    //if has designer order screen pop to
    UINavigationController* nav =  container.navigation;
    for (UIViewController *v in nav.viewControllers) {
        if ([v isKindOfClass:[CommentListViewController class]]) {
            [nav popToViewController:v animated:YES];
            return;
        }
    }
    
    CommentListViewController *v = [[CommentListViewController alloc] init];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showDesignerAuth {
    DesignerAuthViewController *v = [[DesignerAuthViewController alloc] init];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showInfoAuth:(Designer *)designer canEdit:(BOOL)canEdit {
    InfoAuthViewController *v = [[InfoAuthViewController alloc] initWithDesigner:designer canEdit:canEdit];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showInfoAuth:(Designer *)designer canEdit:(BOOL)canEdit fromRegister:(BOOL)fromRegister {
    InfoAuthViewController *v = [[InfoAuthViewController alloc] initWithDesigner:designer canEdit:canEdit fromRegister:fromRegister];
    
    if (container.window.rootViewController == container.navigation) {
        [container.navigation pushViewController:v animated:YES];
    } else {
        [(id)container.window.rootViewController pushViewController:v animated:YES];
    }
}

+ (void)showIDAuth:(Designer *)designer {
    IDAuthViewController *v = [[IDAuthViewController alloc] initWithDesigner:designer];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showServiceArea:(Designer *)designer {
    ServiceAreaViewController *v = [[ServiceAreaViewController alloc] initWithDesigner:designer];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showProductAuth {
    ProductAuthViewController *v = [[ProductAuthViewController alloc] init];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showProductAuthUploadPart1:(Product *)product {
    ProductAuthUploadPart1ViewController *v = [[ProductAuthUploadPart1ViewController alloc] initWithProduct:product];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showProductAuthUploadPart2:(Product *)product {
    ProductAuthUploadPart2ViewController *v = [[ProductAuthUploadPart2ViewController alloc] initWithProduct:product];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showTeamAuth {
    TeamAuthViewController *v = [[TeamAuthViewController alloc] init];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showTeamAuthUpdate:(Team *)team {
    UIViewController *presented = container.navigation.presentedViewController;
    UINavigationController *nav = presented ? (UINavigationController *)presented : container.navigation;
    TeamAuthUpdateViewController *v = [[TeamAuthUpdateViewController alloc] initWithTeam:team];
    [nav pushViewController:v animated:YES];
}

+ (void)showTeamConfigure:(Requirement *)requirement startTime:(NSNumber *)startTime completion:(TeamConfigureCompletionBlock)completion {
    UIViewController *presented = container.navigation.presentedViewController;
    UINavigationController *nav = presented ? (UINavigationController *)presented : container.navigation;
    TeamConfigureViewController *v = [[TeamConfigureViewController alloc] initWithRequirement:requirement startTime:startTime completion:completion];
    [nav pushViewController:v animated:YES];
}

+ (void)showEmailAuthRequest:(Designer *)designer {
    UINavigationController* nav =  container.navigation;
    for (UIViewController *v in nav.viewControllers) {
        if ([v isKindOfClass:[EmailAuthRequestViewController class]]) {
            ((EmailAuthRequestViewController *)v).designer = designer;
            [nav popToViewController:v animated:YES];
            return;
        }
    }
    
    EmailAuthRequestViewController *v = [[EmailAuthRequestViewController alloc] initWithDesigner:designer];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showEmailAuthReviewing:(Designer *)designer {
    UINavigationController* nav =  container.navigation;
    for (UIViewController *v in nav.viewControllers) {
        if ([v isKindOfClass:[EmailAuthReviewingViewController class]]) {
            ((EmailAuthReviewingViewController *)v).designer = designer;
            [nav popToViewController:v animated:YES];
            return;
        }
    }
    
    EmailAuthReviewingViewController *v = [[EmailAuthReviewingViewController alloc] initWithDesigner:designer];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showEmailAuthSuccess:(Designer *)designer {
    UINavigationController* nav =  container.navigation;
    for (UIViewController *v in nav.viewControllers) {
        if ([v isKindOfClass:[EmailAuthSuccessViewController class]]) {
            ((EmailAuthSuccessViewController *)v).designer = designer;
            [nav popToViewController:v animated:YES];
            return;
        }
    }
    
    EmailAuthSuccessViewController *v = [[EmailAuthSuccessViewController alloc] initWithDesigner:designer];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showUserLicense:(Designer *)designer fromRegister:(BOOL)fromRegister {
    [WebViewWithActionController show:[(id)container.window.rootViewController topViewController] withUrl:@"view/user/license.html" shareTopic:@"" actionTitle:@"同意" canBack:NO actionBlock:^{
        DesignerAgreeLicense *request = [[DesignerAgreeLicense alloc] init];
        [HUDUtil showWait];
        [API designerAgreeLicense:request success:^{
            [HUDUtil hideWait];
            [GVUserDefaults standardUserDefaults].isLogin = YES;
            
            if (fromRegister) {
                [self showInfoAuth:designer canEdit:YES fromRegister:fromRegister];
            } else {
                [self showTab];
            }
        } failure:^{
            [HUDUtil hideWait];
        } networkError:^{
            [HUDUtil hideWait];
        }];
    }];
}

+ (void)showOfflineImages:(NSArray *)offlineImages index:(NSInteger)index {
    UIViewController *presented = container.navigation.presentedViewController;
    UINavigationController *nav = presented ? (UINavigationController *)presented : container.navigation;
    ImageDetailViewController *imgDetail = [[ImageDetailViewController alloc] initWithOffline:offlineImages index:index];
    imgDetail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [nav presentViewController:imgDetail animated:YES completion:nil];
}

+ (void)showOnlineImages:(NSArray *)onlineImages index:(NSInteger)index {
    UIViewController *presented = container.navigation.presentedViewController;
    UINavigationController *nav = presented ? (UINavigationController *)presented : container.navigation;
    ImageDetailViewController *imgDetail = [[ImageDetailViewController alloc] initWithOnline:onlineImages index:index];
    imgDetail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [nav presentViewController:imgDetail animated:YES completion:nil];
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

+ (void)refreshSuccess {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView transitionWithView:container.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            container.window.rootViewController = container.navigation;
                        }
                        completion:nil];
    });
}

+ (UIViewController *)getCurrentTapController {
    return container.navigation.topViewController;
}

+ (UIViewController *)getCurrentTopController {
    UINavigationController *nav;
    if (container.window.rootViewController == container.navigation) {
        UIViewController *presented = container.navigation.presentedViewController;
        nav = presented ? (UINavigationController *)presented : container.navigation;
    } else {
        nav = (UINavigationController *)container.window.rootViewController;
    }

    return nav.topViewController;
}

+ (void)logout {
    [GeTuiSdk unbindAlias:[GVUserDefaults standardUserDefaults].userid];
    container.tab = nil;
    [[GVUserDefaults standardUserDefaults] clearValue];
    [[NotificationDataManager shared] clearUnreadCount];
    [API clearCookie];
    [ViewControllerContainer showLogin];
}

@end
