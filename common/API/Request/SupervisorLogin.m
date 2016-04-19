//
//  Login.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "SupervisorLogin.h"

@implementation SupervisorLogin

@dynamic phone;
@dynamic pass;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

- (void)success {
    [GVUserDefaults standardUserDefaults].phone = self.phone;
    [GVUserDefaults standardUserDefaults].loginDate = [[NSDate date] yyyy_MM_dd];
    
    NSMutableDictionary *dict = [DataManager shared].data;
    NSString *usertype = [dict objectForKey:@"usertype"];
    [dict removeObjectForKey:@"usertype"];
    [GVUserDefaults standardUserDefaults].usertype = usertype;

    Supervisor *supervisor = [[Supervisor alloc] initWith:dict];
    [GVUserDefaults standardUserDefaults].userid = [supervisor _id];
    [GVUserDefaults standardUserDefaults].imageid = [supervisor imageid];
    [GVUserDefaults standardUserDefaults].username = [supervisor username];
    [GVUserDefaults standardUserDefaults].isLogin = YES;
}

@end
