//
//  API.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "API.h"

@implementation API

+ (void)leaveComment:(LeaveComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"add_comment" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getComments:(GetComments *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"topic_comments" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getProcess:(GetProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    if (request.processid.length > 0) {
        NSString *url = [NSString stringWithFormat:@"process/%@", request.processid];
        [APIManager GET:url handler:request success:success failure:success networkError:error];
    } else {
        success();
    }
}

+ (void)uploadImageToProcess:(UploadImageToProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"process/add_images" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)deleteImageFromeProcess:(DeleteImageFromProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"process/delete_image" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)uploadImage:(UploadImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager uploadImage:request.image handler:request success:success failure:failure networkError:error];
}

+ (void)reschedule:(Reschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"process/reschedule" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)agreeReschedule:(AgreeReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"process/reschedule/ok" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)rejectReschedule:(RejectReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"process/reschedule/reject" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)feedback:(Feedback *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"feedback" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getUserUnreadCount:(GetUserUnreadCount *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"unread_user_message_count" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getDesignerUnreadCount:(GetDesignerUnreadCount *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [APIManager POST:@"unread_designer_message_count" data:request.data handler:request success:success failure:failure networkError:error];
}

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

+ (void)searchDesignerComment:(SearchDesignerComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_designer_comment" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerNotifyUserToConfirmMeasureHouse:(DesignerNotifyUserToConfirmMeasureHouse *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_remind_user_house_check" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerGetProducts:(DesignerGetProducts *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer/product" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerDeleteProduct:(DesignerDeleteProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer/product/delete" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerGetOneProduct:(ProductHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer/product/one" data:request.data handler:request success:success failure:failure networkError:error];
}

@end



