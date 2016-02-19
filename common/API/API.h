//
//  API.h
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

extern NSString * const kApiUrl;

@interface API : NSObject

+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)userLogin:(UserLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getUserRequirement:(GetUserRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)sendAddRequirement:(SendAddRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)sendUpdateRequirement:(SendUpdateRequirement *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getOrderableDesigners:(GetOrderableDesigners *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)orderDesigner:(OrderDesignder *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)replaceOrderedDesigner:(ReplaceOrderedDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getOrderedDesigner:(GetOrderedDesignder *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)confirmMeasuringHouse:(ConfirmMeasuringHouse *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)evaluateDesigner:(EvaluateDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getRequirementPlans:(GetRequirementPlans *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)choosePlan:(ChoosePlan *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)leaveComment:(LeaveComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getComments:(GetComments *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)startDecoration:(StartDecorationProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getProcessList:(ProcessList *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getProcess:(GetProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)homePageDesigners:(HomePageDesigners *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)productHomePage:(ProductHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerHomePage:(DesignerHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)queryProduct:(QueryProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)verifyPhone:(VerifyPhone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)userSignup:(UserSignup *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)updatePass:(UpdatePass *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)addFavoriateDesigner:(AddFavoriateDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)deleteFavoriateDesigner:(DeleteFavoriteDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)listFavoriateDesigner:(ListFavoriteDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)uploadImage:(UploadImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)uploadImageToProcess:(UploadImageToProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)deleteImageFromeProcess:(DeleteImageFromProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)userGetInfo:(UserGetInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)updateUserInfo:(UpdateUserInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)sectionDone:(SectionDone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getRescheduleNotification:(GetRescheduleNotification *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)reschedule:(Reschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)agreeReschedule:(AgreeReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)rejectReschedule:(RejectReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)feedback:(Feedback *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)listFavoriateProduct:(ListFavoriateProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)listFavoriateBeautifulImage:(ListFavoriateBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)deleteFavoriateProduct:(DeleteFavoriateProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)addFavoriateProduct:(AddFavoriateProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)searchBeautifulImage:(SearchBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getBeautifulImageHomepage:(GetBeautifulImageHomepage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)favoriteBeautifulImage:(FavoriteBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)unfavoriteBeautifulImage:(UnfavoriteBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)wechatLogin:(WeChatLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)userRefreshSession:(RefreshSession *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)bindPhone:(BindPhone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)bindWechat:(BindWechat *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getTopProducts:(GetTopProducts *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;


#pragma mark - designer api
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

@end
