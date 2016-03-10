//
//  UITabBarItem+Badge.m
//  jianfanjia
//
//  Created by Karos on 16/3/10.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "UITabBarItem+Badge.h"

NSString const *UITabBarItem_badgeValueKey = @"UITabBarItem_badgeValueKey";

@implementation UITabBarItem (Badge)

@dynamic badgeCount;

// Badge value to be display
-(NSString *)badgeCount {
    return objc_getAssociatedObject(self, &UITabBarItem_badgeValueKey);
}

-(void)setBadgeCount:(NSString *)badgeCount {
    objc_setAssociatedObject(self, &UITabBarItem_badgeValueKey, badgeCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the badge value check if we need to remove the badge
    if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        UIButton *button = (UIButton *)[(id)self view];
//        button.badgeValue = badgeCount;
//        CGPoint originPointInWindow = [button convertPoint:button.badge.frame.origin toView:[UIApplication sharedApplication].keyWindow];
//        DDLogDebug(@"%@", NSStringFromCGPoint(originPointInWindow));
//        DDLogDebug(@"%@", NSStringFromCGRect(button.badge.frame));
//        CGFloat distance = (originPointInWindow.x + button.badge.bounds.size.width + button.badgePadding) - kScreenWidth;
//        button.badgeOriginX = distance > 0 ?  button.badgeOriginX - distance : button.badgeOriginX;
    }
}

@end
