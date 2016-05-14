//
//  UIViewController+JYZNavigationBarTransition.m
//  jianfanjia
//
//  Created by Karos on 16/5/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "UIViewController+JYZNavigationBarTransition.h"
#import "UINavigationController+JYZNavigationBarTransition.h"
#import <objc/runtime.h>
#import "JYZSwizzle.h"

@implementation UIViewController (JYZNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        JYZSwizzleMethod([self class],
//                        @selector(viewDidLoad),
//                        @selector(jyz_viewDidLoad));
        
        JYZSwizzleMethod([self class],
                         @selector(viewWillAppear:),
                         @selector(jyz_viewWillAppear:));
        
        JYZSwizzleMethod([self class],
                        @selector(viewWillLayoutSubviews),
                        @selector(jyz_viewWillLayoutSubviews));
        
//        JYZSwizzleMethod([self class],
//                         @selector(navigationItem),
//                         @selector(jyz_navigationItem));
        
    });
}

- (void)jyz_viewDidLoad {
//    [self jyz_addTransitionNavigationBarIfNeeded];
    [self jyz_viewDidLoad];
}

- (void)jyz_viewWillAppear:(BOOL)animated {
    [self jyz_addTransitionNavigationBarIfNeeded];
    [self jyz_viewWillAppear:animated];
}

- (void)jyz_viewWillLayoutSubviews {
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    UIViewController *fromViewController = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    fromViewController.view.clipsToBounds = NO;
    toViewController.view.clipsToBounds = NO;
    if (self.navigationController.navigationBar.translucent) {
        [tc containerView].backgroundColor = [UIColor whiteColor];
    }

    if (!self.jyz_transitionNavigationBar) {
        [self jyz_addTransitionNavigationBarIfNeeded];
        [[self.navigationController.navigationBar valueForKey:@"_backgroundView"]
         setHidden:YES];
    }
    
    if (self.jyz_transitionNavigationBar) {
        [self jyz_resizeTransitionNavigationBarFrame];
        [self.view bringSubviewToFront:self.jyz_transitionNavigationBar];
    }
    [self jyz_viewWillLayoutSubviews];
}

//- (UINavigationItem *)jyz_navigationItem {
//    UINavigationItem *item = [self jyz_navigationItem];
//    if (item) {
//        return item;
//    }
//    
//    if (!self.jyz_transitionNavigationItem) {
//        self.jyz_transitionNavigationItem = [[UINavigationItem alloc] init];
//    }
//    
//    self.jyz_transitionNavigationItem.title = @"www";
//    return self.jyz_transitionNavigationItem;
//}

- (void)jyz_resizeTransitionNavigationBarFrame {
    if (!self.view.window) {
        return;
    }
    self.jyz_transitionNavigationBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0);
}

- (void)jyz_addTransitionNavigationBarIfNeeded {
    if ([self isKindOfClass:[UINavigationController class]] || [self isKindOfClass:[UITabBarController class]]) {
        [self hideBackgroundView];
        return;
    }

    if (!self.jyz_transitionNavigationBar) {
        self.jyz_transitionNavigationBar = [[UINavigationBar alloc] init];
        [self jyz_resizeTransitionNavigationBarFrame];
        
        UINavigationBar *bar = self.jyz_transitionNavigationBar;
        bar.backgroundColor = [UIColor clearColor];
        bar.barStyle = self.navigationController.navigationBar.barStyle;
        bar.translucent = self.navigationController.navigationBar.translucent;
        bar.barTintColor = self.navigationController.navigationBar.barTintColor;
        [bar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        bar.shadowImage = self.navigationController.navigationBar.shadowImage;
//        bar.shadowImage = [[UIImage alloc] init];
        
//        self.jyz_transitionNavigationBar.items = @[self.navigationItem];
//        self.jyz_transitionNavigationBar.items = @[[[UINavigationItem alloc] initWithTitle:@"ddddd"]];
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

- (void)hideBackgroundView {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            [view removeFromSuperview];
        }
    }
}

@end
