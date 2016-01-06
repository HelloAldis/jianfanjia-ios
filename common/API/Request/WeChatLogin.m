//
//  WeChatLogin.m
//  jianfanjia
//
//  Created by Karos on 16/1/6.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "WeChatLogin.h"

@implementation WeChatLogin

@dynamic username;
@dynamic sex;
@dynamic image_url;
@dynamic wechat_openid;
@dynamic wechat_unionid;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

- (void)success {
    [GVUserDefaults standardUserDefaults].phone = nil;
    [GVUserDefaults standardUserDefaults].loginDate = [[NSDate date] yyyy_MM_dd];
    
    NSMutableDictionary *dict = [DataManager shared].data;
    NSString *usertype = [dict objectForKey:@"usertype"];
    [dict removeObjectForKey:@"usertype"];
    [GVUserDefaults standardUserDefaults].usertype = usertype;
    [DataManager shared].isWechatFirstLogin = [[dict objectForKey:@"is_wechat_first_login"] boolValue];
    
    if ([kUserTypeUser isEqualToString:usertype]) {
        User *user = [[User alloc] initWith:dict];
        [GVUserDefaults standardUserDefaults].userid = [user _id];
        [GVUserDefaults standardUserDefaults].imageid = [user imageid];
        [GVUserDefaults standardUserDefaults].username = [user username];
    } else if([kUserTypeDesigner isEqualToString:usertype]) {
        Designer *designer = [[Designer alloc] initWith:dict];
        [GVUserDefaults standardUserDefaults].userid = [designer _id];
    }
    [GVUserDefaults standardUserDefaults].isLogin = YES;
    [[NotificationDataManager shared] refreshUnreadCount];
    [GeTuiSdk bindAlias:[GVUserDefaults standardUserDefaults].userid];
}

@end
