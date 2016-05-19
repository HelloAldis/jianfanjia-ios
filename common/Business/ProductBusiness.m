//
//  DesignerBusiness.m
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductBusiness.h"

@implementation ProductBusiness

+ (UIImage *)productAuthTypeImage:(NSString *)authType {
    UIImage *image = nil;
    if ([authType isEqualToString:kProductAuthTypeUnsubmitVerify]) {
        image = [UIImage imageNamed:@"icon_auth_ongoing"];
    } else if ([authType isEqualToString:kProductAuthTypeVerifyPass]) {
        image = [UIImage imageNamed:@"icon_auth_success"];
    } else if ([authType isEqualToString:kProductAuthTypeVerifyNotPass]) {
        image = [UIImage imageNamed:@"icon_auth_fail"];
    } else {
        image = [UIImage imageNamed:@"icon_auth_fail"];
    }
    
    return image;
}

+ (UIColor *)productAuthTypeColor:(NSString *)authType {
    UIColor *color = nil;
    if ([authType isEqualToString:kProductAuthTypeUnsubmitVerify]) {
        color = kExcutionStatusColor;
    } else if ([authType isEqualToString:kProductAuthTypeVerifyPass]) {
        color = kPassStatusColor;
    } else if ([authType isEqualToString:kProductAuthTypeVerifyNotPass]) {
        color = kReminderColor;
    } else {
        color = kReminderColor;
    }
    
    return color;
}

@end
