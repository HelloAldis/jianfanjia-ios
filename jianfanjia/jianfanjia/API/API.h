//
//  API.h
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface API : NSObject

+ (void)login:(Login *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)getUserRequirementSuccess:(void (^)(void))success failure:(void (^)(void))failure;

@end
