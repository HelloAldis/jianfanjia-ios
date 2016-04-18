//
//  API.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "API.h"

@implementation API

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

@end



