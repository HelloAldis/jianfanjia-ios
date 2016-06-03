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
#import "HomePageViewController.h"
#import "RequirementListViewController.h"
#import "MeViewController.h"
#import "ProductViewController.h"
#import "DesignerViewController.h"
#import "RefreshViewController.h"
#import "VerifyPhoneViewController.h"
#import "OrderDesignerViewController.h"
#import "ResetPassViewController.h"
#import "OrderedDesignerViewController.h"
#import "EvaluateDesignerViewController.h"
#import "PlanListViewController.h"
#import "PlanPreviewViewController.h"
#import "PlanPriceDetailViewController.h"
#import "LeaveMessageViewController.h"
#import "AgreementViewController.h"
#import "MyNotificationViewController.h"
#import "DBYSViewController.h"
#import "RequirementCreateViewController.h"
#import "BeautifulImageViewController.h"
#import "CollectDecPhaseViewController.h"
#import "CollectDecStyleViewController.h"
#import "CollectFamilyInfoViewController.h"
#import "BeautifulImageHomePageViewController.h"
#import "AccountBindViewController.h"
#import "BindPhoneViewController.h"
#import "DesignerListViewController.h"
#import "ProductCaseListViewController.h"
#import "SearchViewController.h"
#import "CommentListViewController.h"
#import "NotificationDetailViewController.h"
#import "DecLiveListViewController.h"
#import "OrderTaggedDesignerViewController.h"

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
        if ([NotificationBusiness contains:noti.type inFilter:[NotificationBusiness userAllNotificationsFilter]]) {
            [ViewControllerContainer showNotificationDetail:noti.messageid readBlock:nil];
        } else if ([NotificationBusiness contains:noti.type inFilter:[NotificationBusiness userAllLeaveMsgFilter]]) {
            [ViewControllerContainer showMyComments];
        }
    });
}

+ (UINavigationController *)navigation {
    return container.navigation;
}

+ (void)showAfterLanching {
    if ([GVUserDefaults standardUserDefaults].welcomeVersion < kWelcomeVersion) {
        //显示welcome
        [self showWelcome];
    } else {
        //显示首页
        [self showTab];
    }
}

+ (void)showTab {
    container.tab = [[TabViewController alloc] initWithNibName:nil bundle:nil];
    container.tab.automaticallyAdjustsScrollViewInsets = NO;
    
    HomePageViewController *home = [[HomePageViewController alloc] initWithNibName:nil bundle:nil];
    BeautifulImageViewController *beautifulImg = [[BeautifulImageViewController alloc] initWithNibName:nil bundle:nil];
    RequirementListViewController *requirement = [[RequirementListViewController alloc] initWithNibName:nil bundle:nil];
    MeViewController *me = [[MeViewController alloc] initWithNibName:nil bundle:nil];

    container.tab.tapHome = [[UINavigationController alloc] initWithRootViewController:home];
    container.tab.tapBeautifulImg = [[UINavigationController alloc] initWithRootViewController:beautifulImg];
    container.tab.tapRequirement = [[UINavigationController alloc] initWithRootViewController:requirement];
    container.tab.tapMy = [[UINavigationController alloc] initWithRootViewController:me];

    container.tab.viewControllers = @[container.tab.tapHome, container.tab.tapBeautifulImg, container.tab.tapRequirement, container.tab.tapMy];
    container.navigation = [[UINavigationController alloc] initWithRootViewController:container.tab];
    container.window.rootViewController = container.navigation;
}

+ (void)showWelcome {
    WelcomeViewController *pages =[[WelcomeViewController alloc] initWithNibName:nil bundle:nil];
    container.window.rootViewController = pages;
}

+ (void)showLogin {
    UIViewController *presented = container.navigation.presentedViewController;
    UIViewController *nav = presented ? presented : container.navigation;
    nav = nav ? nav : container.window.rootViewController;
    
    LoginViewController *v = [[LoginViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:v];
    v.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    v.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [nav presentViewController:navi animated:YES completion:nil];
}

+ (void)showSignup {
    UIViewController *presented = container.navigation.presentedViewController;
    UINavigationController *nav = presented ? (UINavigationController *)presented : container.navigation;
    
    LoginViewController *v = [[LoginViewController alloc] init];
    v.showSignup = YES;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:v];
    v.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    v.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [nav presentViewController:navi animated:YES completion:nil];
}

+ (void)showAccountBind {
    AccountBindViewController *v = [[AccountBindViewController alloc] init];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showBindPhone:(BindPhoneEvent)bindPhoneEvent callback:(void(^)(void))callback {
    BindPhoneViewController *v = [[BindPhoneViewController alloc] initWithEvent:bindPhoneEvent];
    v.callback = callback;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:v];
    
    v.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    v.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [container.navigation presentViewController:navi animated:YES completion:nil];
}

+ (void)showVerifyPhone:(VerfityPhoneEvent)verfityPhoneEvent callback:(void(^)(void))callback {
    VerifyPhoneViewController *v = [[VerifyPhoneViewController alloc] initWithEvent:verfityPhoneEvent];
    v.callback = callback;
    
    if (container.window.rootViewController == container.navigation) {
        [((id)container.navigation.presentedViewController) pushViewController:v animated:YES];
    } else {
        [((id)container.window.rootViewController.presentedViewController) pushViewController:v animated:YES];
    }
}

+ (void)showResetPass {
    ResetPassViewController *v = [[ResetPassViewController alloc] init];
    [((id)container.window.rootViewController.presentedViewController) pushViewController:v animated:YES];
}

+ (void)showCollectDecPhase {
    CollectDecPhaseViewController *v = [[CollectDecPhaseViewController alloc] init];
    container.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:v];
}

+ (void)showCollectDecStyle {
    CollectDecStyleViewController *v = [[CollectDecStyleViewController alloc] init];
    UINavigationController *nav =  (UINavigationController *)container.window.rootViewController;
    [nav pushViewController:v animated:YES];
}

+ (void)showCollectFamilyInfo {
    CollectFamilyInfoViewController *v = [[CollectFamilyInfoViewController alloc] init];
    UINavigationController *nav =  (UINavigationController *)container.window.rootViewController;
    [nav pushViewController:v animated:YES];
}

+ (void)showSearch {
    SearchViewController *v = [[SearchViewController alloc] initWithNibName:nil bundle:nil];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showDesignerList {
    DesignerListViewController *v = [[DesignerListViewController alloc] initWithNibName:nil bundle:nil];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showProductCaseList {
    ProductCaseListViewController *v = [[ProductCaseListViewController alloc] initWithNibName:nil bundle:nil];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showDecLiveList {
    DecLiveListViewController *v = [[DecLiveListViewController alloc] initWithNibName:nil bundle:nil];
    [container.navigation pushViewController:v animated:YES];
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

+ (void)showDesigner:(NSString *)designerid {
    UIViewController *presented = container.navigation.presentedViewController;
    UINavigationController *nav = presented ? (UINavigationController *)presented : container.navigation;
    BOOL hasDesigner = NO;
    for (UIViewController *v in nav.viewControllers) {
        if ([v isKindOfClass:[DesignerViewController class]]) {
            hasDesigner = YES;
            DesignerViewController *d = (DesignerViewController *)v;
            if (![d.designerid isEqualToString:designerid]) {
                d.designerid = designerid;
                d.needRefreshDesignerViewController = YES;
            }
            
            [nav popToViewController:v animated:YES];
        }
    }
    
    if (!hasDesigner) {
        DesignerViewController *v = [[DesignerViewController alloc] initWithNibName:nil bundle:nil];
        v.designerid = designerid;
        [nav pushViewController:v animated:YES];
    }
}

+ (void)showRequirementList {
    if (container.tab.selectedViewController != container.tab.tapRequirement) {
        [container.navigation popToRootViewControllerAnimated:NO];
        container.tab.selectedViewController = container.tab.tapRequirement;
    }
    
    [container.navigation popToRootViewControllerAnimated:YES];
}

+ (void)showRequirementCreate:(Requirement *)requirement {
    //if has designer order screen pop to
    UINavigationController* nav =  container.navigation;
    for (UIViewController *v in nav.viewControllers) {
        if ([v isKindOfClass:[RequirementCreateViewController class]]) {
            [nav popToViewController:v animated:YES];
            return;
        }
    }
    
    //no reqirement create
    if (requirement) {
        RequirementCreateViewController *v = [[RequirementCreateViewController alloc] initToViewRequirement:requirement];
        [container.navigation pushViewController:v animated:YES];
    } else {
        RequirementCreateViewController *v = [[RequirementCreateViewController alloc] initToCreateRequirement];
        [container.navigation pushViewController:v animated:YES];
    }
}

+ (void)showOrderDesigner:(Requirement *)requirement {
    Class class = [RequirementBusiness isPkgJiangXinByType:requirement.package_type] ? [OrderTaggedDesignerViewController class] : [OrderDesignerViewController class];
    
    UIViewController *v = [[class alloc] initWithRequirement:requirement];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showReplaceOrderedDesigner:(NSString *)designerid forRequirement:(Requirement *)requirement {
    Class class = [RequirementBusiness isPkgJiangXinByType:requirement.package_type] ? [OrderTaggedDesignerViewController class] : [OrderDesignerViewController class];
    
    UIViewController *v = [[class alloc] initWithRequirement:requirement withToBeReplacedDesigner:designerid];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showPlanList:(NSString *)designerid forRequirement:(Requirement *)requirement {
    PlanListViewController *v = [[PlanListViewController alloc] initWithRequirement:requirement withDesigner:designerid];
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

+ (void)showOrderedDesigner:(Requirement *)requirement {
    OrderedDesignerViewController *v = [[OrderedDesignerViewController alloc] initWithRequirement:requirement];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showEvaluateDesigner:(Designer *)designer withRequirement:(NSString *)requirementid {
    EvaluateDesignerViewController *v = [[EvaluateDesignerViewController alloc] initWithDesigner:designer withRequirment:requirementid];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showAgreement:(Requirement *)requirement popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock {
    AgreementViewController *v = [[AgreementViewController alloc] initWithRequirement:requirement popTo:popTo refresh:refreshBlock];
    [container.navigation pushViewController:v animated:YES];
}

+ (void)showDBYS:(Section *)section process:(NSString *)processid popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock {
    DBYSViewController *v = [[DBYSViewController alloc] initWithSection:section process:processid popTo:popTo refresh:refreshBlock];
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
    [[GVUserDefaults standardUserDefaults] clearValue];
    [[NotificationDataManager shared] clearUnreadCount];
    [API clearCookie];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotification object:nil];
}

@end
