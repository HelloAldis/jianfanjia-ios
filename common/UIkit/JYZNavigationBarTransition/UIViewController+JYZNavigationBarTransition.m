//
//  UIViewController+JYZNavigationBarTransition.m
//  jianfanjia
//
//  Created by Karos on 16/5/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "UIViewController+JYZNavigationBarTransition.h"

@implementation UIViewController (JYZNavigationBarTransition)

- (UINavigationBar *)jyz_transitionNavigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJyz_transitionNavigationBar:(UINavigationBar *)navigationBar {
    objc_setAssociatedObject(self, @selector(km_transitionNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
