//
//  JYZSocialSnsPlatformWechat.h
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "JYZSocialSnsPlatform.h"

@class JYZSocialSnsBaseResp;

@interface JYZSocialSnsPlatformWeibo : JYZSocialSnsPlatform <JYZSocialSnsPlatformProtocol>

+ (void)registerApp:(NSString *)appkey redictURI:(NSString *)redirectURI;

- (void)onReceiveResponse:(JYZSocialSnsBaseResp *)resp;
- (void)login:(UIViewController *)controller compeletion:(JYZLoginCompeletion)completion;
- (void)shareImage:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(JYZShareCompeletion)completion;

@end
