//
//  WeChatLogin.h
//  jianfanjia
//
//  Created by Karos on 16/1/6.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface WeChatLogin : BaseRequest

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *wechat_openid;
@property (nonatomic, strong) NSString *wechat_unionid;

@end
