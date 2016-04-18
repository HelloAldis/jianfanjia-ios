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

+ (void)userLogin:(UserLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)userSignup:(UserSignup *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
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
+ (void)startDecoration:(StartDecorationProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getProcessList:(ProcessList *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)productHomePage:(ProductHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)designerHomePage:(DesignerHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)queryProduct:(QueryProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)addFavoriateDesigner:(AddFavoriateDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)deleteFavoriateDesigner:(DeleteFavoriteDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)listFavoriateDesigner:(ListFavoriteDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)userGetInfo:(UserGetInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)updateUserInfo:(UpdateUserInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)sectionDone:(SectionDone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)listFavoriateProduct:(ListFavoriateProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)listFavoriateBeautifulImage:(ListFavoriateBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)deleteFavoriateProduct:(DeleteFavoriateProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)addFavoriateProduct:(AddFavoriateProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)searchBeautifulImage:(SearchBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)searchDesigner:(SearchDesigner *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)searchProduct:(SearchProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getBeautifulImageHomepage:(GetBeautifulImageHomepage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)favoriteBeautifulImage:(FavoriteBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)unfavoriteBeautifulImage:(UnfavoriteBeautifulImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)wechatLogin:(WeChatLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)userRefreshSession:(RefreshSession *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)bindPhone:(BindPhone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)bindWechat:(BindWechat *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getTopProducts:(GetTopProducts *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)searchUserNotification:(SearchUserNotification *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getUserNotificationDetail:(GetUserNotificationDetail *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)searchUserComment:(SearchUserComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)searchDecLive:(SearchDecLive *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;

@end
