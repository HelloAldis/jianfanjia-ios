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

@end

@implementation LoginEngine

- (void)showLogin:(LoginEngineLoginBlock)loginBlock {
    self.loginBlock = loginBlock;
    
    if (![GVUserDefaults standardUserDefaults].isLogin) {
        [ViewControllerContainer showLogin];
    } else {
        [self executeLoginBlock:YES];
    }
}

- (void)showWechatLogin:(UIViewController *)controller completion:(LoginEngineLoginBlock)loginBlock {
    self.loginBlock = loginBlock;
    
    [[ShareManager shared] wechatLogin:controller compeletion:^(SnsAccountInfo *snsAccount, NSString *error) {
        if (error == nil) {
            WeChatLogin *request = [[WeChatLogin alloc] init];
            request.username = snsAccount.userName;
            request.sex = snsAccount.gender;
            request.image_url = snsAccount.iconURL;
            request.wechat_openid = snsAccount.usid;
            request.wechat_unionid = snsAccount.unionId;
            
            [HUDUtil showWait];
            [API wechatLogin:request success:^{
                [HUDUtil hideWait];
                [self executeLoginBlock:YES];
            } failure:^{
                [HUDUtil hideWait];
            } networkError:^{
                [HUDUtil hideWait];
            }];
        } else {
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

kSynthesizeSingletonForClass(LoginEngine)

@end
