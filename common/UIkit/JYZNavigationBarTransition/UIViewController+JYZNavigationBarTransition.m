//
//  UIViewController+JYZNavigationBarTransition.m
//  jianfanjia
//
//  Created by Karos on 16/5/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "UIViewController+JYZNavigationBarTransition.h"
#import <objc/runtime.h>
#import "JYZSwizzle.h"
#import "BaseViewController.h"

@implementation UIViewController (JYZNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JYZSwizzleMethod([self class],
                         @selector(viewWillAppear:),
                         @selector(jyz_viewWillAppear:));
        
        JYZSwizzleMethod([self class],
                        @selector(viewWillLayoutSubviews),
                        @selector(jyz_viewWillLayoutSubviews));
        
        JYZSwizzleMethod([self class],
                         @selector(navigationItem),
                         @selector(jyz_navigationItem));
    });
}

- (void)jyz_viewWillAppear:(BOOL)animated {
    [self jyz_addTransitionFakeNavigationBar];
    [self jyz_viewWillAppear:animated];
}

- (void)jyz_viewWillLayoutSubviews {
    if (self.jyz_transitionNavigationBar) {
        [self jyz_resizeTransitionNavigationBarFrame];
        [self.view bringSubviewToFront:self.jyz_transitionNavigationBar];
    }
    [self jyz_viewWillLayoutSubviews];
}

- (UINavigationItem *)jyz_navigationItem {
    if (!self.jyz_transitionNavigationItem) {
        self.jyz_transitionNavigationItem = [[UINavigationItem alloc] init];
    }
    
    return self.jyz_transitionNavigationItem;
}

- (void)jyz_resizeTransitionNavigationBarFrame {
    if (!self.view.window) {
        return;
    }
    
    self.jyz_transitionNavigationBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0);
}

- (void)jyz_addTransitionFakeNavigationBar {
    if (!self.jyz_transitionNavigationBar && [self jyz_EnableFakeNavigationBar]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.jyz_transitionNavigationBar = [[UINavigationBar alloc] init];
        [self jyz_resizeTransitionNavigationBarFrame];
        
        UINavigationBar *bar = self.jyz_transitionNavigationBar;
        bar.barStyle = self.navigationController.navigationBar.barStyle;
        bar.translucent = self.navigationController.navigationBar.translucent;
        bar.barTintColor = self.navigationController.navigationBar.barTintColor;
        [bar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        bar.shadowImage = self.navigationController.navigationBar.shadowImage;

        self.jyz_transitionNavigationBar.items = @[self.navigationItem];
        [self.view addSubview:bar];
    }
}

- (UINavigationBar *)jyz_transitionNavigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJyz_transitionNavigationBar:(UINavigationBar *)navigationBar {
    objc_setAssociatedObject(self, @selector(jyz_transitionNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationItem *)jyz_transitionNavigationItem {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJyz_transitionNavigationItem:(UINavigationItem *)navigationItem {
    objc_setAssociatedObject(self, @selector(jyz_transitionNavigationItem), navigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)jyz_EnableFakeNavigationBar {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setJyz_EnableFakeNavigationBar:(BOOL)enable {
    objc_setAssociatedObject(self, @selector(jyz_EnableFakeNavigationBar), @(enable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
