//
//  UIViewController+KRSNavigationBarTransition.m
//  KRSFakeNavigationBar
//
//  Created by Karos on 16/5/14.
//  Copyright © 2016年 karosli. All rights reserved.
//

#import "UIViewController+KRSFakeNavigationBar.h"
#import <objc/runtime.h>
#import "KRSSwizzle.h"

@implementation UIViewController (KRSFakeNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KRSSwizzleMethod([self class],
                         @selector(viewWillAppear:),
                         @selector(krs_viewWillAppear:));
        
        KRSSwizzleMethod([self class],
                         @selector(viewWillLayoutSubviews),
                         @selector(krs_viewWillLayoutSubviews));
        
        KRSSwizzleMethod([self class],
                         @selector(navigationItem),
                         @selector(krs_navigationItem));
        
        KRSSwizzleMethod([self class],
                         @selector(setTitle:),
                         @selector(setKrs_title:));
    });
}

- (void)krs_viewWillAppear:(BOOL)animated {
    [self krs_addTransitionFakeNavigationBar];
    [self krs_viewWillAppear:animated];
}

- (void)krs_viewWillLayoutSubviews {
    [self.transitionCoordinator containerView].backgroundColor = [UIColor whiteColor];
    
    if (self.krs_transitionNavigationBar) {
        [self krs_resizeTransitionNavigationBarFrame];
        [self.view bringSubviewToFront:self.krs_transitionNavigationBar];
    }
    [self krs_viewWillLayoutSubviews];
}

- (UINavigationItem *)krs_navigationItem {
    if (![self krs_EnableFakeNavigationBar]) {
        return self.krs_navigationItem;
    }
    
    if (!self.krs_transitionNavigationItem) {
        self.krs_transitionNavigationItem = [[UINavigationItem alloc] init];
    }
    
    return self.krs_transitionNavigationItem;
}

- (void)setKrs_title:(NSString *)title {
    self.navigationItem.title = title;
    [self setKrs_title:title];
}

- (void)krs_resizeTransitionNavigationBarFrame {
    if (!self.view.window) {
        return;
    }
    
    UIView *backgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    if (backgroundView) {
        self.krs_transitionNavigationBar.frame = CGRectMake(0, 0, CGRectGetWidth(backgroundView.frame), CGRectGetHeight(backgroundView.frame));
    }
}

- (void)krs_addTransitionFakeNavigationBar {
    if (!self.krs_transitionNavigationBar && [self krs_EnableFakeNavigationBar]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.krs_transitionNavigationBar = [[UINavigationBar alloc] init];
        self.krs_transitionNavigationBar.items = @[self.navigationItem];
        [self krs_resizeTransitionNavigationBarFrame];
        [self.view addSubview:self.krs_transitionNavigationBar];
        
        [self krs_updateFakeNavBar];
    }
}

- (void)krs_updateFakeNavBar {
    if (self.krs_transitionNavigationBar) {
        UINavigationBar *bar = self.krs_transitionNavigationBar;
        bar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        bar.barStyle = self.navigationController.navigationBar.barStyle;
        bar.translucent = self.navigationController.navigationBar.translucent;
        bar.barTintColor = self.navigationController.navigationBar.barTintColor;
        [bar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        bar.shadowImage = self.navigationController.navigationBar.shadowImage;
    }
}

- (UINavigationBar *)krs_transitionNavigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKrs_transitionNavigationBar:(UINavigationBar *)navigationBar {
    objc_setAssociatedObject(self, @selector(krs_transitionNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationItem *)krs_transitionNavigationItem {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKrs_transitionNavigationItem:(UINavigationItem *)navigationItem {
    objc_setAssociatedObject(self, @selector(krs_transitionNavigationItem), navigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)krs_EnableFakeNavigationBar {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKrs_EnableFakeNavigationBar:(BOOL)enable {
    objc_setAssociatedObject(self, @selector(krs_EnableFakeNavigationBar), @(enable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
