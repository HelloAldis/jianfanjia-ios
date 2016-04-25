//
//  LoginEngine.m
//  jianfanjia
//
//  Created by Karos on 16/4/1.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "LoginEngine.h"
#import "ViewControllerContainer.h"

@interface LoginEngine ()

@property (nonatomic, copy) LoginEngineLoginBlock loginBlock;
@property (nonatomic, copy) LoginEngineLoginBlock wechatLoginBlock;

@end

@implementation LoginEngine

- (BOOL)isLogin {
    return [GVUserDefaults standardUserDefaults].isLogin;
}

- (void)showLogin:(LoginEngineLoginBlock)loginBlock {
    self.loginBlock = loginBlock;
    
    if (![self isLogin]) {
        [ViewControllerContainer showLogin];
    } else {
        [self executeLoginBlock:YES];
    }
}

- (void)showWechatLogin:(UIViewController *)controller completion:(LoginEngineLoginBlock)wechatLoginBlock {
    self.wechatLoginBlock = wechatLoginBlock;
    
    [HUDUtil showWait];
    [[ShareManager shared] wechatLogin:controller compeletion:^(SnsAccountInfo *snsAccount, NSString *error) {
        if (error == nil) {
            WeChatLogin *request = [[WeChatLogin alloc] init];
            request.username = snsAccount.userName;
            request.sex = snsAccount.gender;
            request.image_url = snsAccount.iconURL;
            request.wechat_openid = snsAccount.usid;
            request.wechat_unionid = snsAccount.unionId;
            
            [API wechatLogin:request success:^{
                [HUDUtil hideWait];
                [self executeWechatLoginBlock:YES];
            } failure:^{
                [HUDUtil hideWait];
            } networkError:^{
                [HUDUtil hideWait];
            }];
        } else {
            [HUDUtil hideWait];
            [HUDUtil showErrText:error];
        }
    }];
}

- (void)executeLoginBlock:(BOOL)logined {
    if (self.loginBlock) {
        self.loginBlock(logined);
        self.loginBlock = nil;
    }
}

- (void)executeWechatLoginBlock:(BOOL)logined {
    if (self.wechatLoginBlock) {
        self.wechatLoginBlock(logined);
        self.wechatLoginBlock = nil;
    }
}

kSynthesizeSingletonForClass(LoginEngine)

@end
