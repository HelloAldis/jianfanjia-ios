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

@interface ViewControllerContainer ()

@property(weak, nonatomic) UIWindow *window;

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

- (void)showAfterLanching {
    if ([UserDefaultManager welcomeVersion] < WELCOME_VERSION) {
        //显示welcome
    } else if ([UserDefaultManager isLogin]) {
        //显示首页
    } else {
        //显示登录
    }
}


@end
