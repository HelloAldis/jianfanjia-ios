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
#import "UserDefaultManager.h"
#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "ProcessViewController.h"

@interface ViewControllerContainer ()

@property(weak, nonatomic) UIWindow *window;
@property(weak, nonatomic) UINavigationController *nav;

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
    if ([UserDefaultManager welcomeVersion] < WELCOME_VERSION) {
        //显示welcome
        WelcomeViewController *pages =[[WelcomeViewController alloc] initWithNibName:nil bundle:nil];
        container.window.rootViewController = pages;
    } else if ([UserDefaultManager isLogin]) {
        //显示首页
        [self showLogin];
        UINavigationController *nav = (UINavigationController *)container.window.rootViewController;
        ProcessViewController *process = [[ProcessViewController alloc] initWithNibName:nil bundle:nil];
        [nav pushViewController:process animated:NO];
    } else {
        //显示登录
        [self showLogin];
    }
}

+ (void) showLogin {
    container.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:
                                           [[LoginViewController alloc] initWithNibName:nil bundle:nil]];
}



@end
