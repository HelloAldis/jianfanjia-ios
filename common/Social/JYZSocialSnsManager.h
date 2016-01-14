//
//  SocialManager.h
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYZSocialSnsConstant.h"

@class JYZSocialSnsPlatform;

@interface JYZSocialSnsManager : NSObject

@property (nonatomic, strong) NSString *currentSharePlatform;

+ (instancetype)shared;
+ (void)showSnsMenu:(UIViewController *)controller flatforms:(NSArray *)flatforms clickHandle:(JYZShareMenuChooseItemBlock)clickHandle;
+ (JYZSocialSnsPlatform *)getSocialPlatformWithName:(NSString *)platformName;
+ (BOOL)handleOpenURL:(NSURL *)url;

@end
