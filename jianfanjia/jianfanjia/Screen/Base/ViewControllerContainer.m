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
#import "SignupSuccessViewController.h"
#import "ResetPassViewController.h"
#import "OrderedDesignerViewController.h"
#import "EvaluateDesignerViewController.h"
#import "PlanListViewController.h"
#import "PlanPreviewViewController.h"
#import "PlanPriceDetailViewController.h"
#import "LeaveMessageViewController.h"
#import "AgreementViewController.h"
#import "ReminderViewController.h"
#import "DBYSViewController.h"
#import "RequirementCreateViewController.h"
#import "ImageDetailViewController.h"

@interface ViewControllerContainer ()

@property(weak, nonatomic) UIWindow *window;
@property(strong, nonatomic) UINavigationController *navTap1;
@property(strong, nonatomic) UINavigationController *navTap2;
@property(strong, nonatomic) UINavigationController *navTap4;

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
        
    }
    
    return self;
}

+ (void)showAfterLanching {
    if ([GVUserDefaults standardUserDefaults].welcomeVersion < kWelconeVersion) {
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
    HomePageViewController *designerlist = [[HomePageViewController alloc] initWithNibName:nil bundle:nil];
    container.navTap1 = [[UINavigationController alloc] initWithRootViewController:designerlist];
    container.navTap1.hidesBottomBarWhenPushed = YES;
    NSDictionary * dict = [NSDictionary dictionaryWithObject:kThemeTextColor forKey: NSForegroundColorAttributeName];
    container.navTap1.navigationBar.titleTextAttributes = dict;
    
    RequirementListViewController *requirementList = [[RequirementListViewController alloc] initWithNibName:nil bundle:nil];
    container.navTap2 = [[UINavigationController alloc] initWithRootViewController:requirementList];
    container.navTap2.hidesBottomBarWhenPushed = YES;
    container.navTap2.navigationBar.titleTextAttributes = dict;
    
    MeViewController *me = [[MeViewController alloc] initWithNibName:nil bundle:nil];
    container.navTap4 = [[UINavigationController alloc] initWithRootViewController:me];
    container.navTap4.hidesBottomBarWhenPushed = YES;
    container.navTap4.navigationBar.titleTextAttributes = dict;
    
    container.tab.viewControllers = @[container.navTap1, container.navTap2, container.navTap4];
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

+ (void)showVerifyPhone:(BOOL)isResetPass {
    VerifyPhoneViewController *v = [[VerifyPhoneViewController alloc] init];
    v.isResetPass = isResetPass;
    UINavigationController *nav =  (UINavigationController *)container.window.rootViewController;
    [nav pushViewController:v animated:YES];
}

+ (void)showSignupSuccess {
    SignupSuccessViewController *v = [[SignupSuccessViewController alloc] init];
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
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showProcess:(NSString *)processid {
    ProcessViewController *v = [[ProcessViewController alloc] initWithProcess:processid];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showProduct:(NSString *)productid {
    UINavigationController* nav =  container.tab.selectedViewController;
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
        [container.tab.selectedViewController pushViewController:v animated:YES];
    }
}

+ (void)showDesigner:(NSString *)designerid {
    UINavigationController* nav =  container.tab.selectedViewController;
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
        [container.tab.selectedViewController pushViewController:v animated:YES];
    }
}

+ (void)showRequirementCreate:(Requirement *)requirement {
    if (container.tab.selectedViewController != container.navTap2) {
        container.tab.selectedViewController = container.navTap2;
    }
    
    
    //if has reqirement create secreen pop to
    UINavigationController* nav =  container.tab.selectedViewController;
    for (UIViewController *v in nav.viewControllers) {
        if ([v isKindOfClass:[RequirementCreateViewController class]]) {
            [nav popToViewController:v animated:YES];
            return;
        }
    }
    
    //no reqirement create
    if (requirement) {
        RequirementCreateViewController *v = [[RequirementCreateViewController alloc] initToViewRequirement:requirement];
        [container.tab.selectedViewController pushViewController:v animated:YES];
    } else {
        RequirementCreateViewController *v = [[RequirementCreateViewController alloc] initToCreateRequirement];
        [container.tab.selectedViewController pushViewController:v animated:YES];
    }
}

+ (void)showOrderDesigner:(Requirement *)requirement {
    if (container.tab.selectedViewController != container.navTap2) {
        container.tab.selectedViewController = container.navTap2;
    }
    
    //if has designer order screen pop to
    UINavigationController* nav =  container.tab.selectedViewController;
    for (UIViewController *v in nav.viewControllers) {
        if ([v isKindOfClass:[OrderDesignerViewController class]]) {
            [nav popToViewController:v animated:YES];
            return;
        }
    }
    
    //no designer order screen
    OrderDesignerViewController *v = [[OrderDesignerViewController alloc] initWithRequirement:requirement];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showReplaceOrderedDesigner:(NSString *)designerid forRequirement:(Requirement *)requirement {
    OrderDesignerViewController *v = [[OrderDesignerViewController alloc] initWithRequirement:requirement withToBeReplacedDesigner:designerid];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showPlanList:(NSString *)designerid forRequirement:(Requirement *)requirement {
    PlanListViewController *v = [[PlanListViewController alloc] initWithRequirement:requirement withDesigner:designerid];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)leaveMessage:(Plan *)plan {
    LeaveMessageViewController *v = [[LeaveMessageViewController alloc] initWithPlan:plan];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)leaveMessage:(NSString *)processid section:(NSString *)section item:(NSString *)item block:(void(^)(void))RefreshBlock {
    LeaveMessageViewController *v = [[LeaveMessageViewController alloc] initWithProcess:processid section:section item:item block:RefreshBlock];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showPlanPerview:(Plan *)plan withOrder:(NSInteger)order forRequirement:(Requirement *)requirement {
    PlanPreviewViewController *v = [[PlanPreviewViewController alloc] initWithPlan:plan withOrder:order forRequirement:requirement];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showPlanPriceDetail:(Plan *)plan {
    PlanPriceDetailViewController *v = [[PlanPriceDetailViewController alloc] initWithPlan:plan];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showOrderedDesigner:(Requirement *)requirement {
    OrderedDesignerViewController *v = [[OrderedDesignerViewController alloc] initWithRequirement:requirement];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showEvaluateDesigner:(Designer *)designer withRequirement:(NSString *)requirementid {
    EvaluateDesignerViewController *v = [[EvaluateDesignerViewController alloc] initWithDesigner:designer withRequirment:requirementid];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showAgreement:(Requirement *)requirement {
    AgreementViewController *v = [[AgreementViewController alloc] initWithRequirement:requirement];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showDBYS:(Section *)section process:(NSString *)processid refresh:(void(^)(void))refreshBlock {
    DBYSViewController *v = [[DBYSViewController alloc] initWithSection:section process:processid refresh:refreshBlock];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showReminder:(NSString *)processid refreshBlock:(void(^)(void))RefreshBlock {
    ReminderViewController *v = [[ReminderViewController alloc] initWithProcess:processid refreshBlock:RefreshBlock];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showRefresh {
    RefreshViewController *refresh = [[RefreshViewController alloc] initWithNibName:nil bundle:nil];
    container.window.rootViewController = refresh;
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
    container.window.rootViewController = container.tab;
}

+ (UIViewController *)getCurrentTapController {
    return ((UINavigationController *)container.tab.selectedViewController).topViewController;
}

+ (void)logout {
    [GeTuiSdk unbindAlias:[GVUserDefaults standardUserDefaults].userid];
    container.tab = nil;
    container.navTap1 = nil;
    container.navTap2 = nil;
    container.navTap4 = nil;
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
    
    [DataManager shared].homePageDesigners = nil;
    [DataManager shared].homePageRequirement = nil;
    [DataManager shared].homePageRequirementDesigners = nil;
    [ViewControllerContainer showLogin];
}

@end
