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
#import "DesignerListViewController.h"
#import "RequirementListViewController.h"
#import "MeViewController.h"

@interface ViewControllerContainer ()

@property(weak, nonatomic) UIWindow *window;
@property(strong, nonatomic) UINavigationController *nav;

@property(strong, nonatomic) UINavigationController *navTap1;
@property(strong, nonatomic) UINavigationController *navTap2;
@property(strong, nonatomic) UINavigationController *navTap3;
@property(strong, nonatomic) UINavigationController *navTap4;

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
    TabViewController *tab = [[TabViewController alloc] initWithNibName:nil bundle:nil];
    DesignerListViewController *designerlist = [[DesignerListViewController alloc] initWithNibName:nil bundle:nil];
    container.navTap1 = [[UINavigationController alloc] initWithRootViewController:designerlist];
    
    RequirementListViewController *requirementList = [[RequirementListViewController alloc] initWithNibName:nil bundle:nil];
    container.navTap2 = [[UINavigationController alloc] initWithRootViewController:requirementList];
    
    ProcessViewController *process = [[ProcessViewController alloc] initWithNibName:nil bundle:nil];
    container.navTap3 = [[UINavigationController alloc] initWithRootViewController:process];
    
    MeViewController *me = [[MeViewController alloc] initWithNibName:nil bundle:nil];
    container.navTap4 = [[UINavigationController alloc] initWithRootViewController:me];
    
    tab.viewControllers = @[container.navTap1, container.navTap2, container.navTap3, container.navTap4];
    container.window.rootViewController = tab;
}

+ (void)showLogin {
    container.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:
                                           [[LoginViewController alloc] initWithNibName:nil bundle:nil]];
}

+ (void)showProcess {
    LeftViewController *left = [[LeftViewController alloc] initWithNibName:nil bundle:nil];
    ProcessViewController *process = [[ProcessViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:process];
    
    RESideMenu *side = [[RESideMenu alloc] initWithContentViewController:nav leftMenuViewController:left rightMenuViewController:nil];
    container.window.rootViewController = side;
}



@end
