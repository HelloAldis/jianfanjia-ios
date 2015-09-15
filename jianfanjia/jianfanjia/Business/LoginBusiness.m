//
//  LoginBusiness.m
//  jianfanjia
//
//  Created by JYZ on 15/9/15.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "LoginBusiness.h"

@implementation LoginBusiness

+ (BOOL)validateLogin:(NSString *)phone pass:(NSString *)pass {
    return ![phone isEmpty] && ![pass isEmpty];
}

@end
