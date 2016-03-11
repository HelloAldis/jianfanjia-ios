//
//  UITabBarItem+Badge.m
//  jianfanjia
//
//  Created by Karos on 16/3/10.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "UITabBarItem+Badge.h"

NSString const *UITabBarItem_badgeNumberKey = @"UITabBarItem_badgeValueKey";

@implementation UITabBarItem (Badge)

@dynamic badgeNumber;

// Badge value to be display
-(NSString *)badgeNumber {
    return objc_getAssociatedObject(self, &UITabBarItem_badgeNumberKey);
}

-(void)setBadgeNumber:(NSString *)badgeNumber {
    objc_setAssociatedObject(self, &UITabBarItem_badgeNumberKey, badgeNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the badge value check if we need to remove the badge
    if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        UIView *view = (UIView *)[(id)self view];
        UIImageView *imageView = (UIImageView *)[view getFirstSubview:[UIImageView class]];
        imageView.badgeNumber = badgeNumber;
    }
}

@end
