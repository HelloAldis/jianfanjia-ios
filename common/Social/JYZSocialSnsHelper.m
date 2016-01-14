//
//  JYZSocialSnsHelper.m
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "JYZSocialSnsHelper.h"

@implementation JYZSocialSnsHelper

+ (JYZSocialSnsAuthResp *)authRespFromWX:(SendAuthResp *)resp {
    JYZSocialSnsAuthResp *jyzResp = [[JYZSocialSnsAuthResp alloc] init];
    jyzResp.errCode = resp.errCode;
    jyzResp.errStr = resp.errStr;
    jyzResp.type = resp.type;
    jyzResp.code = resp.code;
    jyzResp.state = resp.state;
    
    return jyzResp;
}

+ (JYZSocialSnsSendMessageResp *)sendMsgRespFromWX:(SendMessageToWXResp *)resp {
    JYZSocialSnsSendMessageResp *jyzResp = [[JYZSocialSnsSendMessageResp alloc] init];
    jyzResp.errCode = resp.errCode;
    jyzResp.errStr = resp.errStr;
    jyzResp.type = resp.type;
    
    return jyzResp;
}

+ (JYZSocialSnsAuthResp *)authRespFromWeibo:(WBAuthorizeResponse *)resp {
    JYZSocialSnsAuthResp *jyzResp = [[JYZSocialSnsAuthResp alloc] init];
    jyzResp.errCode = resp.statusCode;
    jyzResp.requestUserInfo = resp.requestUserInfo;
    jyzResp.userInfo = resp.userInfo;
    jyzResp.accessToken = resp.accessToken;
    jyzResp.userID = resp.userID;
    jyzResp.refreshToken = resp.refreshToken;
    jyzResp.expirationDate = resp.expirationDate;
    
    return jyzResp;
}

+ (JYZSocialSnsSendMessageResp *)sendMsgRespFromWeibo:(WBSendMessageToWeiboResponse *)resp {
    JYZSocialSnsSendMessageResp *jyzResp = [[JYZSocialSnsSendMessageResp alloc] init];
    jyzResp.errCode = resp.statusCode;
    jyzResp.requestUserInfo = resp.requestUserInfo;
    jyzResp.userInfo = resp.userInfo;
    jyzResp.accessToken = resp.authResponse.accessToken;
    jyzResp.userID = resp.authResponse.userID;
    jyzResp.refreshToken = resp.authResponse.refreshToken;
    jyzResp.expirationDate = resp.authResponse.expirationDate;
    
    return jyzResp;
}

+ (JYZSocialSnsSendMessageResp *)sendMsgRespFromQQ:(SendMessageToQQResp *)resp {
    JYZSocialSnsSendMessageResp *jyzResp = [[JYZSocialSnsSendMessageResp alloc] init];
    jyzResp.errCode = [resp.result integerValue];
    jyzResp.errStr = resp.errorDescription;
    
    return jyzResp;
}

@end
