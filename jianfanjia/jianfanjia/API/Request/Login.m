//
//  Login.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "Login.h"
#import "User.h"
#import "Designer.h"
#import "UserCD.h"
#import "DesignerCD.h"

@implementation Login

@dynamic phone;
@dynamic pass;

- (void)pre {
    [super pre];
}

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
    
    if ([USER_TYPE_USER isEqualToString:usertype]) {
        User *user = [[User alloc] initWith:dict];
        [UserCD insertOrUpdate:user];
        [GVUserDefaults standardUserDefaults].userid = [user _id];
    } else if([USER_TYPE_DESIGNER isEqualToString:usertype]) {
        Designer *designer = [[Designer alloc] initWith:dict];
        [DesignerCD insertOrUpdate:designer];
        [GVUserDefaults standardUserDefaults].userid = [designer _id];
    }
}

@end
