//
//  UIBarButtonItem+Badge.m
//  therichest
//
//  Created by Mike on 2014-05-05.
//  Copyright (c) 2014 Valnet Inc. All rights reserved.
//
#import <objc/runtime.h>
#import "UIBarButtonItem+Badge.h"

NSString const *UIBarButtonItem_badgeNumberKey = @"UIBarButtonItem_badgeNumberKey";

@implementation UIBarButtonItem (Badge)

@dynamic badgeNumber;

// Badge value to be display
-(NSString *)badgeNumber {
    return objc_getAssociatedObject(self, &UIBarButtonItem_badgeNumberKey);
}

-(void)setBadgeNumber:(NSString *)badgeNumber {
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeNumberKey, badgeNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.customView) {
        self.customView.badgeNumber = badgeNumber;
    }
}

@end
