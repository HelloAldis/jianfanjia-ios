//
//  LoginBusiness.m
//  jianfanjia
//
//  Created by JYZ on 15/9/15.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "Business.h"
#import "UserDefaultManager.h"

@implementation Business

+ (BOOL)validateLogin:(NSString *)phone pass:(NSString *)pass {
    return ![phone isEmpty] && ![pass isEmpty];
}

+ (UIImage *)defaultAvatar {
    if ([USER_TYPE_USER isEqualToString: [UserDefaultManager usertype]] ) {
        return [UIImage imageNamed:@"default_user_image"];
    } else if([USER_TYPE_DESIGNER isEqualToString: [UserDefaultManager usertype]]) {
        return [UIImage imageNamed:@"default_designer_image"];
    }
    return [UIImage imageNamed:@"default_user_image"];
}

+ (NSInteger)sectionCount {
    return 7;
}

@end
