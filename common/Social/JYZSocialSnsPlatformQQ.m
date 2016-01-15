//
//  JYZSocialSnsPlatformWechat.m
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "JYZSocialSnsPlatformQQ.h"
#import "JYZSocialSnsConstant.h"
#import "JYZSocialSnsUtil.h"
#import <TencentOpenAPI/TencentOAuth.h>

static NSString *kAccessToken = @"QQAccessToken";
static NSString *kOpenId = @"QQOpenId";
static NSString *kExpireDate = @"QQExpireDate";

static NSString *AppId;
static TencentOAuth *TencentAuth;

@interface JYZSocialSnsPlatformQQ ()

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, copy) void(^ShareBlock)(void) ;

@end

@implementation JYZSocialSnsPlatformQQ

+ (void)registerApp:(NSString *)appid {
    AppId = appid;
    TencentAuth = [[TencentOAuth alloc] initWithAppId:appid andDelegate:(id)[JYZSocialSnsManager shared]];
}

- (void)login:(UIViewController *)controller compeletion:(JYZLoginCompeletion)completion {
    [super login:controller compeletion:completion];

    NSArray *permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];

    [self restoreToken];
    if (self.accessToken && self.openId && self.expirationDate) {
        [TencentAuth setAccessToken:self.accessToken];
        [TencentAuth setOpenId:self.openId];
        [TencentAuth setExpirationDate:self.expirationDate];
        self.ShareBlock();
    } else {
        [TencentAuth authorize:permissions inSafari:NO];
    }
}

- (void)shareImage:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(JYZShareCompeletion)completion {
    [super shareImage:controller image:shareImage title:title description:description targetLink:targetLink completion:completion];
    
    SendMessageToQQReq *req;
    if (targetLink) {
        QQApiNewsObject* img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:targetLink] title:title description:description previewImageData:[JYZSocialSnsUtil thumbnailWithImage:shareImage].data];
        req = [SendMessageToQQReq reqWithContent:img];
    } else {
        QQApiImageObject* img = [QQApiImageObject objectWithData:shareImage.data previewImageData:[JYZSocialSnsUtil thumbnailWithImage:shareImage].data title:title description:description];
        req = [SendMessageToQQReq reqWithContent:img];
    }
    
    QQApiSendResultCode sent;
    if ([self.socialType isEqualToString:JYZShareToQQ]) {
        sent = [QQApiInterface sendReq:req];
    } else {
        sent = [QQApiInterface SendReqToQZone:req];
    }
}

- (void)onReceiveResponse:(id)resp {
    [super onReceiveResponse:resp];
    
    if ([resp isKindOfClass:[JYZSocialSnsAuthResp class]]) {
        [self handleAuthResp:resp];
    } else if ([resp isKindOfClass:[JYZSocialSnsSendMessageResp class]]) {
        [self handleSendMessageResp:resp];
    }
}

#pragma mark - hadle response
- (void)handleAuthResp:(JYZSocialSnsAuthResp *)authResp {
    NSString *errMsg = [self getErrorMessage:authResp.errCode];
    if (errMsg) {
        if (self.shareCompletion) {
            self.shareCompletion(errMsg);
        }
    } else {
        [self saveToken];
    }
}

- (void)handleSendMessageResp:(JYZSocialSnsSendMessageResp *)msgResp {
    NSString *errMsg = [self getErrorMessage:msgResp.errCode];
    if (self.shareCompletion) {
        self.shareCompletion(errMsg);
    }
}

//<TR><TD>error</TD><TD>errorDescription</TD><TD>注释</TD></TR>
//<TR><TD>0</TD><TD>nil</TD><TD>成功</TD></TR>
//<TR><TD>-1</TD><TD>param error</TD><TD>参数错误</TD></TR>
//<TR><TD>-2</TD><TD>group code is invalid</TD><TD>该群不在自己的群列表里面</TD></TR>
//<TR><TD>-3</TD><TD>upload photo failed</TD><TD>上传图片失败</TD></TR>
//<TR><TD>-4</TD><TD>user give up the current operation</TD><TD>用户放弃当前操作</TD></TR>
//<TR><TD>-5</TD><TD>client internal error</TD><TD>客户端内部处理错误</TD></TR>

- (NSString *)getErrorMessage:(NSInteger)errCode {
    NSString *errMsg = nil;
    switch (errCode) {
        case JYZSocialSnsQQLoginSuccess:
            break;
        case JYZSocialSnsQQLoginCancel:
            errMsg = @"用户取消了登录";
            break;
        case JYZSocialSnsQQLoginFail:
            errMsg = @"登录失败";
            break;
        case 0:
            break;
        case -1:
            errMsg = @"参数错误";
            break;
        case -2:
            errMsg = @"该群不在自己的群列表里面";
            break;
        case -3:
            errMsg = @"上传图片失败";
            break;
        case -4:
            errMsg = @"用户取消了操作";
            break;
        case -5:
            errMsg = @"客户端内部处理错误";
            break;
        default:
            break;
    }
    
    return errMsg;
}

#pragma mark - save / restore token
- (void)saveToken {
    self.accessToken = [TencentAuth accessToken];
    self.openId = [TencentAuth openId];
    self.expirationDate = [TencentAuth expirationDate];
    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:self.openId forKey:kOpenId];
    [[NSUserDefaults standardUserDefaults] setObject:self.expirationDate forKey:kExpireDate];
}

- (void)restoreToken {
    self.accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken];
    self.openId = [[NSUserDefaults standardUserDefaults] valueForKey:kOpenId];
    self.expirationDate = [[NSUserDefaults standardUserDefaults] valueForKey:kExpireDate];
}

@end
