//
//  JYZSocialSnsHelper.h
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYZSocialSnsHelper : NSObject

+ (JYZSocialSnsAuthResp *)authRespFromWX:(SendAuthResp *)resp;
+ (JYZSocialSnsSendMessageResp *)sendMsgRespFromWX:(SendMessageToWXResp *)resp;
+ (JYZSocialSnsAuthResp *)authRespFromWeibo:(WBAuthorizeResponse *)resp;
+ (JYZSocialSnsSendMessageResp *)sendMsgRespFromWeibo:(WBSendMessageToWeiboResponse *)resp;
+ (JYZSocialSnsSendMessageResp *)sendMsgRespFromQQ:(SendMessageToQQResp *)resp;

@end
