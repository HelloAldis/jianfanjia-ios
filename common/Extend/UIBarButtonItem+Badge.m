//
//  UIBarButtonItem+Badge.m
//  therichest
//
//  Created by Mike on 2014-05-05.
//  Copyright (c) 2014 Valnet Inc. All rights reserved.
//
#import <objc/runtime.h>
#import "UIBarButtonItem+Badge.h"

NSString const *UIBarButtonItem_badgeValueKey = @"UIBarButtonItem_badgeValueKey";

@implementation UIBarButtonItem (Badge)

@dynamic badgeValue;

// Badge value to be display
-(NSString *)badgeValue {
    return objc_getAssociatedObject(self, &UIBarButtonItem_badgeValueKey);
}

-(void) setBadgeValue:(NSString *)badgeValue {
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the badge value check if we need to remove the badge
    if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        UIButton *button = (UIButton *)[(id)self view];
        button.badgeValue = badgeValue;
        CGPoint originPointInWindow = [button convertPoint:button.badge.frame.origin toView:[UIApplication sharedApplication].keyWindow];
        DDLogDebug(@"%@", NSStringFromCGPoint(originPointInWindow));
        DDLogDebug(@"%@", NSStringFromCGRect(button.badge.frame));
        CGFloat distance = (originPointInWindow.x + button.badge.bounds.size.width + button.badgePadding) - kScreenWidth;
        button.badgeOriginX = distance > 0 ?  button.badgeOriginX - distance : button.badgeOriginX;
    }
}

@end
