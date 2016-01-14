//
//  JYZSocialSnsPlatform.h
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYZSocialSnsConstant.h"
#import "JYZSocialSnsBaseResp.h"
#import "JYZSocialSnsAuthResp.h"
#import "JYZSocialSnsSendMessageResp.h"

@class JYZSocialSnsBaseResp;

@protocol JYZSocialSnsPlatformProtocol <NSObject>

- (void)login:(UIViewController *)controller compeletion:(JYZLoginCompeletion)completion;
- (void)shareImage:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(JYZShareCompeletion)completion;
- (void)onReceiveResponse:(JYZSocialSnsBaseResp *)resp;

@end

@interface JYZSocialSnsPlatform : NSObject

@property (nonatomic, strong) NSString *socialType;
@property (nonatomic, copy) JYZLoginCompeletion loginCompletion;
@property (nonatomic, copy) JYZShareCompeletion shareCompletion;

- (void)login:(UIViewController *)controller compeletion:(JYZLoginCompeletion)completion;
- (void)shareImage:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(JYZShareCompeletion)completion;
- (void)onReceiveResponse:(JYZSocialSnsBaseResp *)resp;

@end
