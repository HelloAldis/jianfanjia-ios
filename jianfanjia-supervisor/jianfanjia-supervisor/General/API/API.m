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

+ (void)supervisorRefreshSession:(RefreshSession *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"supervisor_refresh_session" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)supervisorLogin:(SupervisorLogin *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"supervisor_login" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)supervisorGetInfo:(SupervisorGetInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"supervisor/info/get" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)supervisorUpdateInfo:(SupervisorUpdateInfo *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API POST:@"supervisor/info/update" data:request.data handler:request success:success failure:failure networkError:error];
}

+ (void)supervisorGetProcessList:(SupervisorGetProcessList *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))error {
    [API GET:@"process/list" handler:request success:success failure:failure networkError:error];
}

@end



