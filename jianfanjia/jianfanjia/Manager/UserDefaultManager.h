//
//  UserDefaultManager.h
//  jianfanjia
//
//  Created by JYZ on 15/9/8.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultManager : NSObject

+ (double)welcomeVersion;
+ (void)setWelcomeVersion:(double)version;
+ (BOOL)isLogin;
+ (void)setLogin:(BOOL)login;
+ (NSString *)usertype;
+ (void)setUsertype:(NSString *)usertype;

@end
