//
//  LoginEngine.h
//  jianfanjia
//
//  Created by Karos on 16/4/1.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoginEngineLoginBlock)(BOOL logined);

@interface LoginEngine : NSObject

- (BOOL)isLogin;
- (void)showLogin:(LoginEngineLoginBlock)loginBlock;
- (void)showWechatLogin:(UIViewController *)controller completion:(LoginEngineLoginBlock)wechatLoginBlock;
- (void)executeLoginBlock:(BOOL)logined;
- (void)executeWechatLoginBlock:(BOOL)logined;

kSynthesizeSingletonForHeader(LoginEngine)

@end
