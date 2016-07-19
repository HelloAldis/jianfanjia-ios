//
//  GVUserDefaults+Manager.m
//  jianfanjia
//
//  Created by JYZ on 15/9/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "GVUserDefaults+Manager.h"

@implementation GVUserDefaults (Manager)

@dynamic welcomeVersion;
@dynamic cacheVersion;
@dynamic usertype;
@dynamic userid;
@dynamic isLogin;
@dynamic phone;
@dynamic loginDate;
@dynamic username;
@dynamic imageid;
@dynamic sex;
@dynamic province;
@dynamic city;
@dynamic district;
@dynamic address;
@dynamic dec_progress;
@dynamic respond_speed;
@dynamic service_attitude;
@dynamic auth_type;
@dynamic work_auth_type;
@dynamic email_auth_type;
@dynamic uid_auth_type;
@dynamic product_count;
@dynamic authed_product_count;
@dynamic dec_styles;
@dynamic family_description;
@dynamic wechat_openid;
@dynamic wechat_unionid;
@dynamic wasShowProductCaseUserHelper;
@dynamic wasShowProductCaseRightArrow;

- (void)clearValue {
    [GVUserDefaults standardUserDefaults].isLogin = NO;
    [GVUserDefaults standardUserDefaults].phone = nil;
    [GVUserDefaults standardUserDefaults].usertype = nil;
    [GVUserDefaults standardUserDefaults].userid = nil;
    [GVUserDefaults standardUserDefaults].imageid = nil;
    [GVUserDefaults standardUserDefaults].username = nil;
    [GVUserDefaults standardUserDefaults].loginDate = nil;
    [GVUserDefaults standardUserDefaults].sex = nil;
    [GVUserDefaults standardUserDefaults].province = nil;
    [GVUserDefaults standardUserDefaults].city = nil;
    [GVUserDefaults standardUserDefaults].district = nil;
    [GVUserDefaults standardUserDefaults].address = nil;
    [GVUserDefaults standardUserDefaults].auth_type = nil;
    [GVUserDefaults standardUserDefaults].work_auth_type = nil;
    [GVUserDefaults standardUserDefaults].email_auth_type = nil;
    [GVUserDefaults standardUserDefaults].uid_auth_type = nil;
    [GVUserDefaults standardUserDefaults].product_count = nil;
    [GVUserDefaults standardUserDefaults].authed_product_count = nil;
    [GVUserDefaults standardUserDefaults].wechat_openid = nil;
    [GVUserDefaults standardUserDefaults].wechat_unionid = nil;
}

@end

