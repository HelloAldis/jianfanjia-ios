//
//  SocialManager.h
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYZSocialSnsConstant.h"
#import "JYZSocialSnsHelper.h"

@class SnsAccountInfo;

typedef void(^LoginCompeletion)(SnsAccountInfo *snsAccount, NSString *error);

@interface JYZSocialSnsManager : NSObject

- (void)wechatLogin:(UIViewController *)controller compeletion:(LoginCompeletion)loginCompeletion;
- (void)share:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink delegate:(id)delegate;

kSynthesizeSingletonForHeader(JYZSocialSnsManager)

@end
