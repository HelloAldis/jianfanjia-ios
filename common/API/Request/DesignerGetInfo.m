//
//  UserGetInfo.m
//  jianfanjia
//
//  Created by JYZ on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerGetInfo.h"

@implementation DesignerGetInfo

- (void)success {
    NSMutableDictionary *dict = [DataManager shared].data;
    Designer *designer = [[Designer alloc] initWith:dict];
    [GVUserDefaults standardUserDefaults].userid = [designer _id];
    [GVUserDefaults standardUserDefaults].imageid = [designer imageid];
    [GVUserDefaults standardUserDefaults].username = [designer username];
    [GVUserDefaults standardUserDefaults].sex = [designer sex];
    [GVUserDefaults standardUserDefaults].province = [designer province];
    [GVUserDefaults standardUserDefaults].city = [designer city];
    [GVUserDefaults standardUserDefaults].district = [designer district];
    [GVUserDefaults standardUserDefaults].address = [designer address];
    [GVUserDefaults standardUserDefaults].dec_styles = [designer dec_styles];
    [GVUserDefaults standardUserDefaults].phone = [designer phone];
    [GVUserDefaults standardUserDefaults].respond_speed = [designer respond_speed];
    [GVUserDefaults standardUserDefaults].service_attitude = [designer service_attitude];
    [GVUserDefaults standardUserDefaults].auth_type = [designer auth_type];
    [GVUserDefaults standardUserDefaults].work_auth_type = [designer work_auth_type];
    [GVUserDefaults standardUserDefaults].uid_auth_type = [designer uid_auth_type];
    [GVUserDefaults standardUserDefaults].email_auth_type = [designer email_auth_type];
    [GVUserDefaults standardUserDefaults].product_count = [designer product_count];
    [GVUserDefaults standardUserDefaults].authed_product_count = [designer authed_product_count];
}

@end
