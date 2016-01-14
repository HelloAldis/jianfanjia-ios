//
//  SocialManager.m
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "JYZSocialSnsManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "JYZSocialSnsConstant.h"
#import "JYZSocialSnsHelper.h"
#import "JYZSocialSnsAuthResp.h"
#import "JYZSocialSnsPlatformWechat.h"
#import "JYZSocialSnsPlatformQQ.h"
#import "JYZSocialSnsPlatformWeibo.h"
#import "JYZShareMenuView.h"

static NSMutableDictionary *snsPlatformDic;

@interface JYZSocialSnsManager () <WXApiDelegate, WeiboSDKDelegate, QQApiInterfaceDelegate>

@end

@implementation JYZSocialSnsManager

+ (void)initialize {
    snsPlatformDic = [NSMutableDictionary dictionary];
}

+ (instancetype)shared {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return  instance;
}

+ (void)showSnsMenu:(UIViewController *)controller flatforms:(NSArray *)flatforms clickHandle:(JYZShareMenuChooseItemBlock)clickHandle {
    [JYZShareMenuView show:controller datasource:flatforms block:clickHandle];
}

+ (JYZSocialSnsPlatform *)getSocialPlatformWithName:(NSString *)platformName {
    if ([snsPlatformDic.allKeys containsObject:platformName]) {
        return snsPlatformDic[platformName];
    } else {
        JYZSocialSnsPlatform *snsPlatform;
        if ([platformName isEqualToString:JYZShareToWechatSession] || [platformName isEqualToString:JYZShareToWechatTimeline]) {
            snsPlatform = [[JYZSocialSnsPlatformWechat alloc] init];
        } else if ([platformName isEqualToString:JYZShareToQQ] || [platformName isEqualToString:JYZShareToQzone]) {
            snsPlatform = [[JYZSocialSnsPlatformQQ alloc] init];
        } else if ([platformName isEqualToString:JYZShareToWeibo]) {
            snsPlatform = [[JYZSocialSnsPlatformWeibo alloc] init];
        }
        
        snsPlatform.socialType = platformName;
        snsPlatformDic[platformName] = snsPlatform;
        return snsPlatform;
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    BOOL flag = [TencentOAuth HandleOpenURL:url];
    flag = !flag ? [QQApiInterface handleOpenURL:url delegate:[JYZSocialSnsManager shared]] : YES;
    flag = !flag ? [WeiboSDK handleOpenURL:url delegate:[JYZSocialSnsManager shared]] : YES;
    flag = !flag ? [WXApi handleOpenURL:url delegate:[JYZSocialSnsManager shared]] : YES;
    
    return  flag;
}

#pragma mark - WXApiDelegate
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void)onReq:(id)req {
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(id)resp {
    // Wechat
    if ([resp isKindOfClass:[BaseResp class]]) {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            JYZSocialSnsAuthResp *jyzResp = [JYZSocialSnsHelper authRespFromWX:(SendAuthResp *)resp];
            
            JYZSocialSnsPlatform *snsPlatform = [JYZSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
            if ([snsPlatform conformsToProtocol:@protocol(JYZSocialSnsPlatformProtocol)]) {
                [snsPlatform onReceiveResponse:jyzResp];
            }
        } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
            JYZSocialSnsSendMessageResp *jyzResp = [JYZSocialSnsHelper sendMsgRespFromWX:(SendMessageToWXResp *)resp];
            
            JYZSocialSnsPlatform *snsPlatform = [JYZSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
            if ([snsPlatform conformsToProtocol:@protocol(JYZSocialSnsPlatformProtocol)]) {
                [snsPlatform onReceiveResponse:jyzResp];
            }
        }

    }
    // QQ
    else if ([resp isKindOfClass:[QQBaseResp class]]) {
        if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
            JYZSocialSnsSendMessageResp *jyzResp = [JYZSocialSnsHelper sendMsgRespFromQQ:(SendMessageToQQResp *)resp];
            
            JYZSocialSnsPlatform *snsPlatform = [JYZSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
            if ([snsPlatform conformsToProtocol:@protocol(JYZSocialSnsPlatformProtocol)]) {
                [snsPlatform onReceiveResponse:jyzResp];
            }
        }
    }
}

#pragma mark - WeiboSDKDelegate
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)resp {
    if ([resp isKindOfClass:[WBAuthorizeResponse class]]) {
        JYZSocialSnsAuthResp *jyzResp = [JYZSocialSnsHelper authRespFromWeibo:(WBAuthorizeResponse *)resp];
        
        JYZSocialSnsPlatform *snsPlatform = [JYZSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
        if ([snsPlatform conformsToProtocol:@protocol(JYZSocialSnsPlatformProtocol)]) {
            [snsPlatform onReceiveResponse:jyzResp];
        }
    } else if ([resp isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        JYZSocialSnsSendMessageResp *jyzResp = [JYZSocialSnsHelper sendMsgRespFromWeibo:(WBSendMessageToWeiboResponse *)resp];
        
        JYZSocialSnsPlatform *snsPlatform = [JYZSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
        if ([snsPlatform conformsToProtocol:@protocol(JYZSocialSnsPlatformProtocol)]) {
            [snsPlatform onReceiveResponse:jyzResp];
        }
    }
}

#pragma mark - TencentSessionDelegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    JYZSocialSnsAuthResp *jyzResp = [[JYZSocialSnsAuthResp alloc] init];
    jyzResp.errCode = JYZSocialSnsQQLoginSuccess;
    
    JYZSocialSnsPlatform *snsPlatform = [JYZSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
    if ([snsPlatform conformsToProtocol:@protocol(JYZSocialSnsPlatformProtocol)]) {
        [snsPlatform onReceiveResponse:jyzResp];
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    JYZSocialSnsAuthResp *jyzResp = [[JYZSocialSnsAuthResp alloc] init];
    jyzResp.errCode = cancelled ? JYZSocialSnsQQLoginCancel : JYZSocialSnsQQLoginFail;
    
    JYZSocialSnsPlatform *snsPlatform = [JYZSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
    if ([snsPlatform conformsToProtocol:@protocol(JYZSocialSnsPlatformProtocol)]) {
        [snsPlatform onReceiveResponse:jyzResp];
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    JYZSocialSnsAuthResp *jyzResp = [[JYZSocialSnsAuthResp alloc] init];
    jyzResp.errCode = JYZSocialSnsQQLoginFail;
    
    JYZSocialSnsPlatform *snsPlatform = [JYZSocialSnsManager getSocialPlatformWithName:self.currentSharePlatform];
    if ([snsPlatform conformsToProtocol:@protocol(JYZSocialSnsPlatformProtocol)]) {
        [snsPlatform onReceiveResponse:jyzResp];
    }
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response {

}

@end
