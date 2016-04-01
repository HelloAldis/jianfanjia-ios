//
//  JYZSocialSnsPlatformWechat.m
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "JYZSocialSnsPlatformWeibo.h"
#import "JYZSocialSnsConstant.h"
#import "JYZSocialSnsUtil.h"

static NSString *AppKey;
static NSString *RedirectURI;

@interface JYZSocialSnsPlatformWeibo () <WXApiDelegate>

@property (nonatomic, strong) NSString *accessToken;

@end

@implementation JYZSocialSnsPlatformWeibo

+ (void)registerApp:(NSString *)appkey redictURI:(NSString *)redirectURI {
    AppKey = appkey;
    RedirectURI = redirectURI ? redirectURI : @"https://api.weibo.com/oauth2/default.html";
//    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:appkey];
}

- (void)login:(UIViewController *)controller compeletion:(JYZLoginCompeletion)completion {
    [super login:controller compeletion:completion];
}

- (void)shareImage:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(JYZShareCompeletion)completion {
    [super shareImage:controller image:shareImage title:title description:description targetLink:targetLink completion:completion];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = RedirectURI;
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    NSData *descriptionData = [description dataUsingEncoding:NSUTF8StringEncoding];
    NSData *linkData = [targetLink dataUsingEncoding:NSUTF8StringEncoding];

    DDLogDebug(@"description bytes: %lu, link bytes: %lu", descriptionData.length, linkData.length);
    if (descriptionData.length + linkData.length > 280) {
        description = [description substringToIndex:MAX((280 - linkData.length) / 2, 0)];
        description = [description stringByReplacingCharactersInRange:NSMakeRange(description.length - 3, 3) withString:@"..."];
    }
    message.text = [NSString stringWithFormat:@"%@%@", description, targetLink];
    
//    if (targetLink) {
//        WBWebpageObject *webpage = [WBWebpageObject object];
//        webpage.objectID = targetLink;
//        webpage.title = title;
//        webpage.description = description;
//        webpage.thumbnailData = [JYZSocialSnsUtil thumbnailWithImage:shareImage].data;
//        webpage.webpageUrl = targetLink;
//        message.mediaObject = webpage;
//    } else {
        WBImageObject *image = [WBImageObject object];
        image.imageData = shareImage.data;
        message.imageObject = image;
//    }

    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    [WeiboSDK sendRequest:request];
}

- (void)onReceiveResponse:(id)resp {
    [super onReceiveResponse:resp];
    
    if ([resp isKindOfClass:[JYZSocialSnsAuthResp class]]) {
        [self handleAuthResponse:resp];
    } else if ([resp isKindOfClass:[JYZSocialSnsSendMessageResp class]]) {
        [self handleSendMessageResponse:resp];
    }
}

#pragma mark - hadle response
//WeiboSDKResponseStatusCodeSuccess               = 0,//成功
//WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
//WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
//WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
//WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
//WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
//WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
//WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
//WeiboSDKResponseStatusCodeUnknown               = -100,

- (void)handleSendMessageResponse:(JYZSocialSnsSendMessageResp *)msgResp {
    NSString *errMsg = [self getErrorMessage:msgResp];
    
    if (self.shareCompletion) {
        self.shareCompletion(errMsg);
    }
}

- (void)handleAuthResponse:(JYZSocialSnsAuthResp *)authResp {
    NSString *errMsg = [self getErrorMessage:authResp];
    
    if (self.shareCompletion) {
        self.shareCompletion(errMsg);
        return;
    }
    
    self.accessToken = authResp.accessToken;
}

- (NSString *)getErrorMessage:(JYZSocialSnsBaseResp *)resp {
    NSString *errMsg = resp.errStr;
    switch (resp.errCode) {
        case WeiboSDKResponseStatusCodeSuccess:
            break;
        case WeiboSDKResponseStatusCodeUserCancel:
            errMsg = @"用户取消了操作";
            break;
        case WeiboSDKResponseStatusCodeSentFail:
            errMsg = @"发送失败";
            break;
        case WeiboSDKResponseStatusCodeAuthDeny:
            errMsg = @"授权失败";
            break;
        case WeiboSDKResponseStatusCodeUserCancelInstall:
            errMsg = @"用户取消安装微博客户端";
            break;
        case WeiboSDKResponseStatusCodePayFail:
            errMsg = @"支付失败";
            break;
        case WeiboSDKResponseStatusCodeShareInSDKFailed:
            errMsg = @"分享失败";
            break;
        case WeiboSDKResponseStatusCodeUnsupport:
            errMsg = @"不支持的请求";
            break;
        case WeiboSDKResponseStatusCodeUnknown:
            errMsg = @"未知错误";
            break;
            
        default:
            break;
    }
    
    return errMsg;
}

@end
