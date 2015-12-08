//
//  Signup.m
//  jianfanjia
//
//  Created by JYZ on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UserSignup.h"

@implementation UserSignup

@dynamic phone;
@dynamic pass;
@dynamic code;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

- (void)success {
    [GVUserDefaults standardUserDefaults].phone = self.phone;
    [SSKeychain setPassword:self.pass forService:kKeychainService account:self.phone];
    [GVUserDefaults standardUserDefaults].loginDate = [[NSDate date] yyyy_MM_dd];
    
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
