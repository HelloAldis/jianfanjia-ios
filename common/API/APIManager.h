//
//  API.h
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

#if defined PRO
// Product 中的配置
#define kApiUrl @"http://www.jianfanjia.com/api/v2/app/"
#define kMApiUrl @"http://m.jianfanjia.com/api/v2/app/"

#elif defined TEST
// Test 中的配置
#define kApiUrl @"http://dev.jianfanjia.com:8888/api/v2/app/"
#define kMApiUrl @"http://devm.jianfanjia.com:8888/api/v2/app/"

#elif defined DEBUG
// Dev 中的配置
#define kApiUrl @"http://dev.jianfanjia.com/api/v2/app/"
#define kMApiUrl @"http://devm.jianfanjia.com/api/v2/app/"

#endif

#ifndef kApiUrl
// 默认的使用 product 中的配置
#define kApiUrl @"http://www.jianfanjia.com/api/v2/app/"
#define kMApiUrl @"http://m.jianfanjia.com/api/v2/app/"

#endif


@interface APIManager : NSObject

+ (BOOL)isSessionExpired;
+ (void)clearCookie;
+ (void)GET:(NSString *)url handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))networkError;
+ (void)POST:(NSString *)url data:(NSDictionary *)data handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))networkError;
+ (void)uploadImage:(UIImage *)image handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))networkError;

@end
