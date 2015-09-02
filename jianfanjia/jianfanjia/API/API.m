//
//  API.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "API.h"
#import "Pods.h"


static AFHTTPRequestOperationManager *_manager;

@implementation API

+ (void)initialize {
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://127.0.0.1/api/v1/"]];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
}

+ (void)GET:(NSString *)url success:(void (^)(void))success failure:(void (^)(void))failure {
    [_manager GET:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          }];
}

+ (void)POST:(NSString *)url data:(NSDictionary *)data success:(void (^)(void))success failure:(void (^)(void))failure {
    [_manager POST:url
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          }];
}

+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"/api/v1/" data:[request data] success:success failure:failure];
}

+ (void)login:(Login *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"login" data:[request data] success:success failure:failure];
}

+ (void)getUserRequirementSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    [API GET:@"user/requirement" success:success failure:failure];
}

@end



