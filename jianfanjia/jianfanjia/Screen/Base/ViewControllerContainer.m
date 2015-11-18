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
#import "ImageDetailViewController.h"
#import "DesignerViewController.h"
#import "RefreshViewController.h"
#import "VerifyPhoneViewController.h"
#import "OrderDesignerViewController.h"
#import "SignupSuccessViewController.h"
#import "ResetPassViewController.h"

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
    
    RequirementListViewController *requirementList = [[RequirementListViewController alloc] initWithNibName:nil bundle:nil];
    container.navTap2 = [[UINavigationController alloc] initWithRootViewController:requirementList];
    container.navTap2.hidesBottomBarWhenPushed = YES;
    
    MeViewController *me = [[MeViewController alloc] initWithNibName:nil bundle:nil];
    container.navTap4 = [[UINavigationController alloc] initWithRootViewController:me];
    container.navTap4.hidesBottomBarWhenPushed = YES;
    
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

+ (void)showProcess {
    LeftViewController *left = [[LeftViewController alloc] initWithNibName:nil bundle:nil];
    ProcessViewController *process = [[ProcessViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:process];
    
    RESideMenu *side = [[RESideMenu alloc] initWithContentViewController:nav leftMenuViewController:left rightMenuViewController:nil];
    container.window.rootViewController = side;
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

+ (void)showOrderDesigner:(Requirement *)requirement {
    OrderDesignerViewController *v = [[OrderDesignerViewController alloc] initWithRequirement:requirement];
    [container.tab.selectedViewController pushViewController:v animated:YES];
}

+ (void)showImageDetail:(NSArray *)images withIndex:(NSInteger)index {
    ImageDetailViewController *v = [[ImageDetailViewController alloc] initWithNibName:nil bundle:nil];
    v.imageArray = images;
    v.index = index;
    [container.tab.selectedViewController presentViewController:v animated:YES completion:^{}];
}

+ (void)showRefresh {
    RefreshViewController *refresh = [[RefreshViewController alloc] initWithNibName:nil bundle:nil];
    container.window.rootViewController = refresh;
}

+ (void)refreshSuccess {
    container.window.rootViewController = container.tab;
}

+ (void)logout {
    container.tab = nil;
    container.navTap1 = nil;
    container.navTap2 = nil;
    container.navTap4 = nil;
    [ViewControllerContainer showLogin];
}


@end
