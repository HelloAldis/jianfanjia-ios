//
//  API.h
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"

@interface BaseAPI : APIManager

+ (void)sendVerifyCode:(SendVerifyCode *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)verifyPhone:(VerifyPhone *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)updatePass:(UpdatePass *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)feedback:(Feedback *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)leaveComment:(LeaveComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getComments:(GetComments *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getProcess:(GetProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getUserUnreadCount:(GetUserUnreadCount *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getDesignerUnreadCount:(GetDesignerUnreadCount *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)uploadImageToProcess:(UploadImageToProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)deleteImageFromeProcess:(DeleteImageFromProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)uploadImage:(UploadImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)reschedule:(Reschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)agreeReschedule:(AgreeReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)rejectReschedule:(RejectReschedule *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;

@end
