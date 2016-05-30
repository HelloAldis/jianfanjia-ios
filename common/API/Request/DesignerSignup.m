//
//  Signup.m
//  jianfanjia
//
//  Created by JYZ on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerSignup.h"

@implementation DesignerSignup

@dynamic phone;
@dynamic pass;
@dynamic code;

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
    
    if ([DesignerBusiness isDesignerAgreeLicense:designer.agreee_license]) {
        [GVUserDefaults standardUserDefaults].isLogin = YES;
    }
}

@end
