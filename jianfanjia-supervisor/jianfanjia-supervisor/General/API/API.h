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

+ (void)leaveComment:(LeaveComment *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getComments:(GetComments *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)getProcess:(GetProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)uploadImageToProcess:(UploadImageToProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)deleteImageFromeProcess:(DeleteImageFromProcess *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)uploadImage:(UploadImage *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)supervisorRefreshSession:(RefreshSession *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)supervisorLogin:(SupervisorLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)supervisorGetInfo:(SupervisorGetInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)supervisorUpdateInfo:(SupervisorUpdateInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;
+ (void)supervisorGetProcessList:(SupervisorGetProcessList *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error;

@end
