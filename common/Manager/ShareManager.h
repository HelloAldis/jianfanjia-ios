//
//  ShareManager.h
//  jianfanjia
//
//  Created by Karos on 16/1/5.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ShareTopicBeautifulImage;
extern NSString * const ShareTopicApp;
extern NSString * const ShareTopicDecStrategy;

@class SnsAccountInfo;

typedef void(^LoginCompeletion)(SnsAccountInfo *snsAccount, NSString *error);

@interface ShareManager : NSObject

- (void)wechatLogin:(UIViewController *)controller compeletion:(LoginCompeletion)loginCompeletion;
- (void)share:(UIViewController *)controller topic:(NSString *)topic image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink delegate:(id)delegate;


kSynthesizeSingletonForHeader(ShareManager)

@end
