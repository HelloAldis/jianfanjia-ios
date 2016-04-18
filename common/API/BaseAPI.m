//
//  API.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseAPI.h"

@implementation BaseAPI

+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"send_verify_code" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)verifyPhone:(VerifyPhone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"verify_phone" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)updatePass:(UpdatePass *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"update_pass" data:request.data handler:request success:success failure:failure networkError:error];
}

@end



