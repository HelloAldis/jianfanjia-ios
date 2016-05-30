//
//  Login.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "DesignerLogin.h"

@implementation DesignerLogin

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
    
    Designer *designer = [[Designer alloc] initWith:dict];
    [GVUserDefaults standardUserDefaults].userid = [designer _id];
    [GVUserDefaults standardUserDefaults].imageid = [designer imageid];
    [GVUserDefaults standardUserDefaults].username = [designer username];
}

@end
