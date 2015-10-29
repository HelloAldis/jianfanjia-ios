//
//  Login.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "UserLogin.h"

@implementation UserLogin

@dynamic phone;
@dynamic pass;

- (void)failure {
    [HUDUtil hideWait];
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

- (void)success {
    [GVUserDefaults standardUserDefaults].x = self.phone;
    [GVUserDefaults standardUserDefaults].xx = self.pass;
    
    NSMutableDictionary *dict = [DataManager shared].data;
    NSString *usertype = [dict objectForKey:@"usertype"];
    [dict removeObjectForKey:@"usertype"];
    [GVUserDefaults standardUserDefaults].usertype = usertype;
    
    if ([kUserTypeUser isEqualToString:usertype]) {
        User *user = [[User alloc] initWith:dict];
        [GVUserDefaults standardUserDefaults].userid = [user _id];
    } else if([kUserTypeDesigner isEqualToString:usertype]) {
        Designer *designer = [[Designer alloc] initWith:dict];
        [GVUserDefaults standardUserDefaults].userid = [designer _id];
    }
}

@end
