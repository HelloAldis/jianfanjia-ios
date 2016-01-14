//
//  JYZSocialSnsConfigCenter.m
//  jianfanjia
//
//  Created by Karos on 16/1/14.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "JYZSocialSnsConfigCenter.h"
#import "JYZSocialSnsConfig.h"
#import "JYZSocialSnsConstant.h"
#import "JYZSocialSnsPlatformWechat.h"
#import "JYZSocialSnsPlatformQQ.h"
#import "JYZSocialSnsPlatformWeibo.h"

@interface JYZSocialSnsConfigCenter ()

@property (nonatomic, strong) NSMutableDictionary *appConfigure;

@end

@implementation JYZSocialSnsConfigCenter

+ (void)initialize {
    if (self == [JYZSocialSnsConfigCenter self]) {
        
    }
}

+ (instancetype)shared {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return  instance;
}

- (NSMutableDictionary *)appConfigure {
    if (!_appConfigure) {
        _appConfigure = [NSMutableDictionary dictionary];
    }
    
    return _appConfigure;
}

- (void)registerWX:(NSString *)appid appsecret:(NSString *)appsecret {
    [JYZSocialSnsPlatformWechat registerApp:appid secret:appsecret];
}

- (void)registerQQ:(NSString *)appid {
    [JYZSocialSnsPlatformQQ registerApp:appid];
}

- (void)registerWeibo:(NSString *)appkey rediectURI:(NSString *)redirectURI {
    [JYZSocialSnsPlatformWeibo registerApp:appkey redictURI:redirectURI];
}

@end
