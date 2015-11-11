//
//  AccountBusiness.m
//  jianfanjia
//
//  Created by JYZ on 15/10/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AccountBusiness.h"

@implementation AccountBusiness

+ (BOOL)validateLogin:(NSString *)phone pass:(NSString *)pass {
    return ![phone isEmpty] && ![pass isEmpty];
}

+ (BOOL)validatePhone:(NSString *)phone {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(13[0-9]{9}|15[012356789][0-9]{8}|18[0123456789][0-9]{8}|147[0-9]{8}|170[0-9]{8}|177[0-9]{8})$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:phone options:0 range:NSMakeRange(0, [phone length])];
    return match != nil;
}

+ (BOOL)validatePass:(NSString *)pass {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\@A-Za-z0-9\\!\\#\\$\%\\^\\&\\*\\.\\~]{6,30}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:pass options:0 range:NSMakeRange(0, [pass length])];
    return match != nil;
}

+ (UIImage *)defaultAvatar {
    if ([kUserTypeUser isEqualToString: [GVUserDefaults standardUserDefaults].usertype] ) {
        return [UIImage imageNamed:@"default_user_image"];
    } else if([kUserTypeDesigner isEqualToString: [GVUserDefaults standardUserDefaults].usertype]) {
        return [UIImage imageNamed:@"default_designer_image"];
    }
    return [UIImage imageNamed:@"default_user_image"];
}

@end
