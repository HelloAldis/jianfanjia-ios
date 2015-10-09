//
//  AccountBusiness.m
//  jianfanjia
//
//  Created by JYZ on 15/10/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AccountBusiness.h"
#import "Type.h"

@implementation AccountBusiness

+ (BOOL)validateLogin:(NSString *)phone pass:(NSString *)pass {
    return ![phone isEmpty] && ![pass isEmpty];
}

+ (UIImage *)defaultAvatar {
    if ([USER_TYPE_USER isEqualToString: [GVUserDefaults standardUserDefaults].usertype] ) {
        return [UIImage imageNamed:@"default_user_image"];
    } else if([USER_TYPE_DESIGNER isEqualToString: [GVUserDefaults standardUserDefaults].usertype]) {
        return [UIImage imageNamed:@"default_designer_image"];
    }
    return [UIImage imageNamed:@"default_user_image"];
}

@end
