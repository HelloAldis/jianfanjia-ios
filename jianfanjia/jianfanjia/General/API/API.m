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

+ (void)userLogin:(UserLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_login" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)userSignup:(UserSignup *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user_signup" data:request.data handler:request success:success failure:failure networkError:error];
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

+ (void)startDecoration:(StartDecorationProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user/process" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getProcessList:(ProcessList *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API GET:@"process/list" handler:request success:success failure:success networkError:error];
}

+ (void)productHomePage:(ProductHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"product_home_page" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)designerHomePage:(DesignerHomePage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"designer_home_page" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)queryProduct:(QueryProduct *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_designer_product" data:request.data handler:request success:success failure:failure networkError:error];
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

+ (void)userGetInfo:(UserGetInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API GET:@"user/info" handler:request success:success failure:failure networkError:error];
}

+ (void)updateUserInfo:(UpdateUserInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"user/info" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)sectionDone:(SectionDone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/done_section" data:request.data handler:request success:success failure:failure networkError:error];
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

+ (void)searchUserComment:(SearchUserComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_user_comment" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchDecLive:(SearchDecLive *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_share" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)addDiarySet:(AddDiarySet *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"add_diary_set" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)updateDiarySet:(AddDiarySet *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"update_diary_set" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getMyDiarySet:(SearchDiarySet *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"my_diary_set" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchDiarySet:(SearchDiarySet *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_diary_set" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)searchDiary:(SearchDiary *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"search_diary" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)addDiary:(AddDiary *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"add_diary" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)deleteDiary:(DeleteDiary *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"delete_diary" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)zanDiary:(ZanDiary *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/diary/add" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getDiarySetDetail:(GetDiarySetDetail *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"diary_set_info" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getDiaryDetail:(GetDiaryDetail *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"diary_info" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getDiaryUpdation:(GetDiaryUpdation *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"get_diary_changes" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)favoriteDiarySet:(FavoriteDiarySet *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/diaryset/add" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)unfavoriteDiarySet:(UnfavoriteDiarySet *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/diaryset/delete" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getTopDiarySet:(GetTopDiarySet *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"top_diary_set" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)listFavoriateDiarySet:(ListFavoriateDiarySet *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"favorite/diarySet/list" data:request.data handler:request success:success failure:failure networkError:error];
}

@end
