//
//  API.h
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"
#import "BaseAPI.h"

@interface API : BaseAPI

+ (void)designerRefreshSession:(RefreshSession *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerLogin:(DesignerLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerSignup:(DesignerSignup *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerGetInfo:(DesignerGetInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getDesignerProcess:(GetDesignerProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerGetUserRequirement:(DesignerGetUserRequirements *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerGetRequirementPlan:(DesignerGetRequirementPlans *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerRejectUser:(DesignerRejectUser *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerRespondUser:(DesignerRespondUser *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerConfigAgreement:(DesignerConfigAgreement *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerDoneSectionItem:(DesignerDoneSectionItem *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerUploadYsImage:(UploadYsImageToProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerDeleteYsImage:(DeleteYsImageFromProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerNotifyUserToDBYS:(NotifyUserToDBYS *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)searchDesignerNotification:(SearchDesignerNotification *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getDesignerNotificationDetail:(GetDesignerNotificationDetail *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)searchDesignerComment:(SearchDesignerComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerNotifyUserToConfirmMeasureHouse:(DesignerNotifyUserToConfirmMeasureHouse *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;

@end
