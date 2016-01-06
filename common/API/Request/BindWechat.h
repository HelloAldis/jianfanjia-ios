//
//  BindWechat.h
//  jianfanjia
//
//  Created by Karos on 16/1/6.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface BindWechat : BaseRequest

@property (nonatomic, strong) NSString *wechat_unionid;
@property (nonatomic, strong) NSString *wechat_openid;

@end
