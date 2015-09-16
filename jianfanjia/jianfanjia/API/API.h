//
//  API.h
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

#define API_URL @"http://127.0.0.1/api/v1/"

@interface API : NSObject

+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)login:(Login *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)getUserRequirement:(GetUserRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure;


@end
