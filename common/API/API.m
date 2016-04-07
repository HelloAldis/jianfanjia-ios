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
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kApiUrl]];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.requestSerializer.HTTPShouldHandleCookies = YES;
    _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    serializer.removesKeysWithNullValues = YES;
    _manager.responseSerializer = serializer;
}

+ (void)clearCookie {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

+ (void)GET:(NSString *)url handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))networkError {
    [request pre];
    [_manager GET:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject){
               [request handle:responseObject success:success failure:failure];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [request handleHttpError:error networkError:networkError];
          }];
}

+ (void)POST:(NSString *)url data:(NSDictionary *)data handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))networkError {
    [request pre];
    [_manager POST:url
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [request handle:responseObject success:success failure:failure];
   
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [request handleHttpError:error networkError:networkError];
          }];
}

+ (void)uploadImage:(UIImage *)image handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))networkError {
    [request pre];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kApiUrl, @"image/upload"];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    mutableRequest.HTTPMethod = @"POST";
    [mutableRequest setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setHTTPBody:[image data]];

    AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:mutableRequest success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [request handle:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        [request handleHttpError:error networkError:networkError];
    }];
    
    [_manager.operationQueue addOperation:operation];
}

+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"send_verify_code" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)userLogin:(UserLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_login" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getUserRequirement:(GetUserRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API GET:@"user_my_requirement_list" handler:request success:success failure:failure networkError:error];
}

+ (void)sendAddRequirement:(SendAddRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_add_requirement" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)sendUpdateRequirement:(SendUpdateRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_update_requirement" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getOrderableDesigners:(GetOrderableDesigners *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designers_user_can_order" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)orderDesigner:(OrderDesignder *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_order_designer" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)replaceOrderedDesigner:(ReplaceOrderedDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_change_ordered_designer" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getOrderedDesigner:(GetOrderedDesignder *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_ordered_designers" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)confirmMeasuringHouse:(ConfirmMeasuringHouse *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_house_checked" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)evaluateDesigner:(EvaluateDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_evaluate_designer" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getRequirementPlans:(GetRequirementPlans *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_requirement_plans" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)choosePlan:(ChoosePlan *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user/plan/final" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)leaveComment:(LeaveComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"add_comment" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getComments:(GetComments *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"topic_comments" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)startDecoration:(StartDecorationProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user/process" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getProcessList:(ProcessList *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API GET:@"process/list" handler:request success:success failure:success networkError:error];
}

+ (void)getProcess:(GetProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    if (request.processid.length > 0) {
        NSString *url = [NSString stringWithFormat:@"process/%@", request.processid];
        [API GET:url handler:request success:success failure:success networkError:error];
    } else {
        success();
    }
}

+ (void)productHomePage:(ProductHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"product_home_page" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerHomePage:(DesignerHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_home_page" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void) queryProduct:(QueryProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_designer_product" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)verifyPhone:(VerifyPhone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"verify_phone" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)userSignup:(UserSignup *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_signup" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)updatePass:(UpdatePass *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"update_pass" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)addFavoriateDesigner:(AddFavoriateDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/designer/add" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)deleteFavoriateDesigner:(DeleteFavoriteDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/designer/delete" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)listFavoriateDesigner:(ListFavoriteDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/designer/list" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)uploadImageToProcess:(UploadImageToProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/add_images" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)deleteImageFromeProcess:(DeleteImageFromProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/delete_image" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)uploadImage:(UploadImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API uploadImage:request.image handler:request success:success failure:failure networkError:error];
}

+ (void)userGetInfo:(UserGetInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API GET:@"user/info" handler:request success:success failure:failure networkError:error];
}

+ (void)updateUserInfo:(UpdateUserInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user/info" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)sectionDone:(SectionDone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/done_section" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getRescheduleNotification:(GetRescheduleNotification *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API GET:@"process/reschedule/all" handler:request success:success failure:success networkError:error];
}

+ (void)reschedule:(Reschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/reschedule" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)agreeReschedule:(AgreeReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/reschedule/ok" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)rejectReschedule:(RejectReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/reschedule/reject" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)feedback:(Feedback *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"feedback" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchBeautifulImage:(SearchBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_beautiful_image" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchDesigner:(SearchDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_designer" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchProduct:(SearchProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_designer_product" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)listFavoriateProduct:(ListFavoriateProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/product/list" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)listFavoriateBeautifulImage:(ListFavoriateBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/beautiful_image/list" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)deleteFavoriateProduct:(DeleteFavoriateProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/product/delete" data:request.data handler:request success:success failure:failure networkError:success];
}

+ (void)addFavoriateProduct:(AddFavoriateProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/product/add" data:request.data handler:request success:success failure:failure networkError:error];
}
    + (void)getBeautifulImageHomepage:(GetBeautifulImageHomepage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"beautiful_image_homepage" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)favoriteBeautifulImage:(FavoriteBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/beautiful_image/add" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)unfavoriteBeautifulImage:(UnfavoriteBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/beautiful_image/delete" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)wechatLogin:(WeChatLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_wechat_login" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)userRefreshSession:(RefreshSession *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_refresh_session" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)bindPhone:(BindPhone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_bind_phone" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)bindWechat:(BindWechat *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_bind_wechat" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getTopProducts:(GetTopProducts *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"top_products" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchUserNotification:(SearchUserNotification *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_user_message" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getUserNotificationDetail:(GetUserNotificationDetail *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_message_detail" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getUserUnreadCount:(GetUserUnreadCount *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"unread_user_message_count" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchUserComment:(SearchUserComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_user_comment" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchDecLive:(SearchDecLive *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_share" data:request.data handler:request success:success failure:failure networkError:error];
}

#pragma mark - designer api
+ (void)designerRefreshSession:(RefreshSession *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_refresh_session" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerLogin:(DesignerLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_login" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerSignup:(DesignerSignup *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_signup" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerGetInfo:(DesignerGetInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API GET:@"designer/info" handler:request success:success failure:failure networkError:error];
}

+ (void)getDesignerProcess:(GetDesignerProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API GET:@"process/list" handler:request success:success failure:failure networkError:error];
}

+ (void)designerGetUserRequirement:(DesignerGetUserRequirements *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_get_user_requirements" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerGetRequirementPlan:(DesignerGetRequirementPlans *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_requirement_plans" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerRejectUser:(DesignerRejectUser *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer/user/reject" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerRespondUser:(DesignerRespondUser *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer/user/ok" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerConfigAgreement:(DesignerConfigAgreement *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"config_contract" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerDoneSectionItem:(DesignerDoneSectionItem *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/done_item" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerUploadYsImage:(UploadYsImageToProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/ysimage" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerDeleteYsImage:(DeleteYsImageFromProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/ysimage/delete" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerNotifyUserToDBYS:(NotifyUserToDBYS *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/can_ys" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchDesignerNotification:(SearchDesignerNotification *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_designer_message" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getDesignerNotificationDetail:(GetDesignerNotificationDetail *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_message_detail" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getDesignerUnreadCount:(GetDesignerUnreadCount *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"unread_designer_message_count" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchDesignerComment:(SearchDesignerComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_designer_comment" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerNotifyUserToConfirmMeasureHouse:(DesignerNotifyUserToConfirmMeasureHouse *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_remind_user_house_check" data:request.data handler:request success:success failure:failure networkError:error];
}

@end



