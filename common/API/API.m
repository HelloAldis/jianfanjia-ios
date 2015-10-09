//
//  API.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "API.h"


static AFHTTPRequestOperationManager *_manager;

@implementation API

+ (void)initialize {
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:API_URL]];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
}

+ (void)GET:(NSString *)url handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [_manager GET:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject){
               [request handle:responseObject success:success failure:failure];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [request handleHttpError:error failure:failure];
          }];
}

+ (void)POST:(NSString *)url data:(NSDictionary *)data handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [request pre];
    [_manager POST:url
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [request handle:responseObject success:success failure:failure];
   
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [request handleHttpError:error failure:failure];
          }];
}

+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"/api/v1/" data:[request data] handler:request success:success failure:failure];
}

+ (void)login:(Login *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"login" data:[request data] handler:request success:success failure:failure];
}

+ (void)getUserRequirement:(GetUserRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API GET:@"user/requirement" handler:request success:success failure:failure];
}

+ (void)getProcessList:(ProcessList *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API GET:@"process/list" handler:request success:success failure:success];
}

+ (void)getProcess:(GetProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    if (request.processid.length > 0) {
        NSString *url = [NSString stringWithFormat:@"process/%@", request.processid];
        [API GET:url handler:request success:success failure:success];
    } else {
        success();
    }
}

@end



