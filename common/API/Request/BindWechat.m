//
//  BindWechat.m
//  jianfanjia
//
//  Created by Karos on 16/1/6.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BindWechat.h"

@implementation BindWechat

@dynamic wechat_unionid;
@dynamic wechat_openid;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

@end
