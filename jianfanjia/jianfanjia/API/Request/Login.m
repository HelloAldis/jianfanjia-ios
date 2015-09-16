//
//  Login.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "Login.h"

@implementation Login

@dynamic phone;
@dynamic pass;

- (void)pre {
    [super pre];
    [HUDUtil showWait];
}

- (void)all {
    [HUDUtil hideWait];
}

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

- (void)success {
    [UserDefaultManager setLogin:YES];
}

@end
