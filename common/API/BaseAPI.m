//
//  API.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseAPI.h"

@implementation BaseAPI

+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"send_verify_code" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)verifyPhone:(VerifyPhone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"verify_phone" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)updatePass:(UpdatePass *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"update_pass" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)feedback:(Feedback *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"feedback" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)leaveComment:(LeaveComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"add_comment" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getComments:(GetComments *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"topic_comments" data:[request data] handler:request success:success failure:failure networkError:error];
}

+ (void)getProcess:(GetProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    if (request.processid.length > 0) {
        NSString *url = [NSString stringWithFormat:@"process/%@", request.processid];
        [API GET:url handler:request success:success failure:success networkError:error];
    } else {
        success();
    }
}

+ (void)getUserUnreadCount:(GetUserUnreadCount *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"unread_user_message_count" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)getDesignerUnreadCount:(GetDesignerUnreadCount *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"unread_designer_message_count" data:request.data handler:request success:success failure:failure networkError:error];
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

+ (void)reschedule:(Reschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/reschedule" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)agreeReschedule:(AgreeReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/reschedule/ok" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)rejectReschedule:(RejectReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"process/reschedule/reject" data:request.data handler:request success:success failure:failure networkError:error];
}

@end



