//
//  JYZSocialSnsConfigCenter.h
//  jianfanjia
//
//  Created by Karos on 16/1/14.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYZSocialSnsConfigCenter : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary *appConfigure;

+ (instancetype)shared;

- (void)registerWX:(NSString *)appid appsecret:(NSString *)appsecret;
- (void)registerQQ:(NSString *)appid;
- (void)registerWeibo:(NSString *)appkey rediectURI:(NSString *)redirectURI;

@end
