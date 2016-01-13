//
//  JYZSocialSnsConstant.h
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#ifndef JYZSocialSnsConstant_h
#define JYZSocialSnsConstant_h

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

/**
 分享平台
 */
typedef NS_ENUM(NSInteger, JYZSocialSnsType) {
    JYZSocialSnsTypeWechatSession,
    JYZSocialSnsTypeWechatTimeline,
    JYZSocialSnsTypeMobileQQ,
    JYZSocialSnsTypeQzone,
    JYZSocialSnsTypeWeibo,
};

#endif /* JYZSocialSnsConstant_h */
