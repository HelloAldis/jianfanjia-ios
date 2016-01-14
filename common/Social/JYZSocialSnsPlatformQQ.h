//
//  JYZSocialSnsPlatformWechat.h
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "JYZSocialSnsPlatform.h"

typedef NS_ENUM(NSInteger, JYZSocialSnsQQLoginErrorCode) {
    JYZSocialSnsQQLoginSuccess = 2000,
    JYZSocialSnsQQLoginFail,
    JYZSocialSnsQQLoginCancel,
};

@class JYZSocialSnsBaseResp;

@interface JYZSocialSnsPlatformQQ : JYZSocialSnsPlatform <JYZSocialSnsPlatformProtocol>

+ (void)registerApp:(NSString *)appid;

- (void)onReceiveResponse:(JYZSocialSnsBaseResp *)resp;
- (void)login:(UIViewController *)controller compeletion:(JYZLoginCompeletion)completion;
- (void)shareImage:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(JYZShareCompeletion)completion;

@end
