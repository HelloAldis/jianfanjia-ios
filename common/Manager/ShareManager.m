//
//  ShareManager.m
//  jianfanjia
//
//  Created by Karos on 16/1/5.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ShareManager.h"
#import "AppDelegate.h"
#import "MobClickSocialAnalytics.h"

NSString * const ShareTopicBeautifulImage = @"BeautifulImage";
NSString * const ShareTopicApp = @"APP";
NSString * const ShareTopicDecStrategy = @"DecStrategy";
NSString * const ShareTopicActivity = @"Activity";
NSString * const ShareTopicDecLive = @"DecLive";

@implementation ShareManager

- (void)wechatLogin:(UIViewController *)controller compeletion:(LoginCompeletion)loginCompeletion {
    JYZSocialSnsPlatform *snsPlatform = [JYZSocialSnsManager getSocialPlatformWithName:JYZShareToWechatSession];
    [snsPlatform login:controller compeletion:^(JYZSocialSnsAccountInfo *snsAccount, NSString *errorMsg) {
        if (errorMsg) {
            if (loginCompeletion) {
                loginCompeletion(nil, errorMsg);
            }
        } else {
            if (loginCompeletion) {
                SnsAccountInfo *sns = [[SnsAccountInfo alloc] init];
                sns.userName = snsAccount.userName;
                sns.usid = snsAccount.usid;
                sns.unionId = snsAccount.unionId;
                sns.iconURL = snsAccount.iconURL;
                sns.gender = [snsAccount.gender isEqualToNumber:@(0)] ? @"1" : @"0";
                loginCompeletion(sns, nil);
            }
        }
    }];
}

- (void)share:(UIViewController *)controller topic:(NSString *)topic image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink delegate:(id)delegate {
    NSMutableArray *snsArr = [NSMutableArray array];
    
    if ([JYZSocialSnsConfigCenter isWXAppInstalled]) {
        [snsArr addObject:JYZShareToWechatSession];
        [snsArr addObject:JYZShareToWechatTimeline];
    }
    
    if ([JYZSocialSnsConfigCenter isQQInstalled]) {
        [snsArr addObject:JYZShareToQQ];
        [snsArr addObject:JYZShareToQzone];
    }
    
    if ([JYZSocialSnsConfigCenter isWeiboAppInstalled]) {
        [snsArr addObject:JYZShareToWeibo];
    }

    if (snsArr.count == 0) {
        [HUDUtil showErrText:@"请安装微信，QQ或者微博。"];
        return;
    }
    
    [JYZSocialSnsManager showSnsMenu:controller flatforms:snsArr clickHandle:^(id value) {
        [self socialShareAnalytics:value topic:topic];
        JYZSocialSnsPlatform *snsPlatform = [JYZSocialSnsManager getSocialPlatformWithName:value];
        [snsPlatform shareImage:controller image:shareImage title:title description:description targetLink:targetLink completion:^(NSString *errorMsg) {
            if (errorMsg) {
                [HUDUtil showErrText:errorMsg];
            } else {
                [HUDUtil showSuccessText:@"分享成功"];
            }
        }];
    }];
}

- (void)socialShareAnalytics:(NSString *)platform topic:(NSString *)topic {
    NSString *umplatform;
    if ([platform isEqualToString:JYZShareToWechatSession]) {
        umplatform = MobClickSocialTypeWxsesion;
    } else if ([platform isEqualToString:JYZShareToWechatTimeline]) {
        umplatform = MobClickSocialTypeWxtimeline;
    } else if ([platform isEqualToString:JYZShareToQQ]) {
        umplatform = MobClickSocialTypeQQ;
    } else if ([platform isEqualToString:JYZShareToQzone]) {
        umplatform = MobClickSocialTypeQzone;
    } else  {
        umplatform = MobClickSocialTypeSina;
    }
    
    MobClickSocialWeibo *weibo = [[MobClickSocialWeibo alloc] initWithPlatformType:umplatform weiboId:nil usid:nil param:nil];
    [MobClickSocialAnalytics postWeiboCounts:@[weibo] appKey:kUMengAppKey topic:topic completion:nil];
}

kSynthesizeSingletonForClass(ShareManager)

@end
