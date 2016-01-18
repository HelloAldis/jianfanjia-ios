//
//  JYZSocialSnsConstant.h
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#ifndef JYZSocialSnsConstant_h
#define JYZSocialSnsConstant_h

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "JYZSocialSnsAccountInfo.h"

/**
 微信好友
 */
extern NSString *const JYZShareToWechatSession;

/**
 微信朋友圈
 */
extern NSString *const JYZShareToWechatTimeline;

/**
 手机QQ
 */
extern NSString *const JYZShareToQQ;

/**
 QQ空间
 */
extern NSString *const JYZShareToQzone;

/**
 新浪微博
 */
extern NSString *const JYZShareToWeibo;

typedef void(^JYZLoginCompeletion)(JYZSocialSnsAccountInfo *snsAccount, NSString *errorMsg);
typedef void(^JYZShareCompeletion)(NSString *errorMsg);
typedef void(^JYZShareMenuChooseItemBlock)(id value);

#endif /* JYZSocialSnsConstant_h */
