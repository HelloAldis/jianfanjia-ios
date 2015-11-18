//
//  API.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "API.h"

NSString * const kApiUrl = @"http://101.200.191.159/api/v2/app/";
static AFHTTPRequestOperationManager *_manager;

@implementation API

+ (void)initialize {
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kApiUrl]];
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
    [API POST:@"send_verify_code" data:[request data] handler:request success:success failure:failure];
}

+ (void)userLogin:(UserLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"user_login" data:[request data] handler:request success:success failure:failure];
}

+ (void)getUserRequirement:(GetUserRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API GET:@"user_my_requirement_list" handler:request success:success failure:failure];
}

+ (void)sendAddRequirement:(SendAddRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"user_add_requirement" data:[request data] handler:request success:success failure:failure];
}

+ (void)getOrderableDesigners:(GetOrderableDesigners *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"designers_user_can_order" data:[request data] handler:request success:success failure:failure];
}

+ (void)orderDesigner:(OrderDesignder *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"user_order_designer" data:[request data] handler:request success:success failure:failure];
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

+ (void)homePageDesigners:(HomePageDesigners *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"home_page_designers" data:request.data handler:request success:success failure:failure];
}

+ (void)productHomePage:(ProductHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"product_home_page" data:request.data handler:request success:success failure:failure];
}

+ (void)designerHomePage:(DesignerHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"designer_home_page" data:request.data handler:request success:success failure:failure];
}

+ (void) queryProduct:(QueryProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"search_designer_product" data:request.data handler:request success:success failure:failure];
}

+ (void)verifyPhone:(VerifyPhone *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"verify_phone" data:request.data handler:request success:success failure:failure];
}

+ (void)userSignup:(UserSignup *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"user_signup" data:request.data handler:request success:success failure:failure];
}

+ (void)updatePass:(UpdatePass *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"update_pass" data:request.data handler:request success:success failure:failure];
}

@end



