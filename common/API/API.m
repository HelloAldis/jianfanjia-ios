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
    [request pre];
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

+ (void)uploadImage:(UIImage *)image handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure  {
    [request pre];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kApiUrl, @"image/upload"];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    mutableRequest.HTTPMethod = @"POST";
    [mutableRequest setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setHTTPBody:[image data]];

    AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:mutableRequest success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [request handle:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        [request handleHttpError:error failure:failure];
    }];
    
    [_manager.operationQueue addOperation:operation];
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

+ (void)replaceOrderedDesigner:(ReplaceOrderedDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"user_change_ordered_designer" data:[request data] handler:request success:success failure:failure];
}

+ (void)getOrderedDesigner:(GetOrderedDesignder *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"user_ordered_designers" data:[request data] handler:request success:success failure:failure];
}

+ (void)confirmMeasuringHouse:(ConfirmMeasuringHouse *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"designer_house_checked" data:[request data] handler:request success:success failure:failure];
}

+ (void)evaluateDesigner:(EvaluateDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"user_evaluate_designer" data:[request data] handler:request success:success failure:failure];
}

+ (void)getRequirementPlans:(GetRequirementPlans *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"user_requirement_plans" data:[request data] handler:request success:success failure:failure];
}

+ (void)choosePlan:(ChoosePlan *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"user/plan/final" data:[request data] handler:request success:success failure:failure];
}

+ (void)leaveComment:(LeaveComment *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"add_comment" data:[request data] handler:request success:success failure:failure];
}

+ (void)getComments:(GetComments *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"topic_comments" data:[request data] handler:request success:success failure:failure];
}

+ (void)startDecoration:(StartDecorationProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"user/process" data:[request data] handler:request success:success failure:failure];
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

+ (void)addFavoriateDesigner:(AddFavoriateDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"favorite/designer/add" data:request.data handler:request success:success failure:failure];
}

+ (void)deleteFavoriateDesigner:(DeleteFavoriteDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"favorite/designer/delete" data:request.data handler:request success:success failure:failure];
}

+ (void)listFavoriateDesigner:(ListFavoriteDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"favorite/designer/list" data:request.data handler:request success:success failure:failure];
}

+ (void)uploadImageToProcess:(UploadImageToProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"process/add_images" data:request.data handler:request success:success failure:failure];
}

+ (void)deleteImageFromeProcess:(DeleteImageFromProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"process/delete_image" data:request.data handler:request success:success failure:failure];
}

+ (void)uploadImage:(UploadImage *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API uploadImage:request.image handler:request success:success failure:failure];
}

+ (void)userGetInfo:(UserGetInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API GET:@"user/info" handler:request success:success failure:failure];
}

+ (void)sectionDone:(SectionDone *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"process/done_section" data:request.data handler:request success:success failure:failure];
}

+ (void)getRescheduleNotification:(GetRescheduleNotification *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API GET:@"process/reschedule/all" handler:request success:success failure:success];
}

+ (void)reschedule:(Reschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"process/reschedule" data:request.data handler:request success:success failure:failure];
}

+ (void)agreeReschedule:(AgreeReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"process/reschedule/ok" data:request.data handler:request success:success failure:failure];
}

+ (void)rejectReschedule:(RejectReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"process/reschedule/reject" data:request.data handler:request success:success failure:failure];
}

+ (void)feedback:(Feedback *)request success:(void (^)(void))success failure:(void (^)(void))failure {
    [API POST:@"feedback" data:request.data handler:request success:success failure:failure];
}

@end



