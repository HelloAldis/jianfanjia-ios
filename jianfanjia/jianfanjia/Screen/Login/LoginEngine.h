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

- (void)showLogin:(LoginEngineLoginBlock)loginBlock;
- (void)showWechatLogin:(UIViewController *)controller completion:(LoginEngineLoginBlock)loginBlock;
- (void)executeLoginBlock:(BOOL)logined;

kSynthesizeSingletonForHeader(LoginEngine)

@end
