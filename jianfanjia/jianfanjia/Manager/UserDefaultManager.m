//
//  UserDefaultManager.m
//  jianfanjia
//
//  Created by JYZ on 15/9/8.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#define SET_OBJECT(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define GET_OBJECT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define SET_DOUBLE(value, key) [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key]
#define GET_DOUBLE(key) [[NSUserDefaults standardUserDefaults] doubleForKey:key]
#define SET_BOOL(value, key) [[NSUserDefaults standardUserDefaults] setBool:value forKey:key]
#define GET_BOOL(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]


#import "UserDefaultManager.h"

@implementation UserDefaultManager

+ (double)welcomeVersion {
    return GET_DOUBLE(@"welcome_version");
}

+ (void)setWelcomeVersion:(double)version {
    SET_DOUBLE(version ,@"welcome_version");
}

+ (BOOL)isLogin {
    return GET_BOOL(@"login");
}

+ (void)setLogin:(BOOL)login {
    SET_BOOL(login, @"login");
}

@end
