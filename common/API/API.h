//
//  API.h
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

extern NSString * const kApiUrl;

@interface API : NSObject

+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)userLogin:(UserLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)getUserRequirement:(GetUserRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)getProcessList:(ProcessList *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)getProcess:(GetProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)homePageDesigners:(HomePageDesigners *)request success:(void (^)(void))success failure:(void (^)(void))failure;
+ (void)productHomeGage:(ProductHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure;

@end
