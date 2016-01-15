//
//  ShareManager.m
//  jianfanjia
//
//  Created by Karos on 16/1/5.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ShareManager.h"
#import "AppDelegate.h"

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

- (void)share:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink delegate:(id)delegate {
    NSMutableArray *snsArr = [NSMutableArray array];
    
//    if (kIsInstalledWechat) {
        [snsArr addObject:JYZShareToWechatSession];
        [snsArr addObject:JYZShareToWechatTimeline];
//    }
    
//    if (kIsInstalledQQ) {
        [snsArr addObject:JYZShareToQQ];
        [snsArr addObject:JYZShareToQzone];
//    }
    
//    if (kIsInstalledWeibo) {
        [snsArr addObject:JYZShareToWeibo];
//    }
    
    if (snsArr.count == 0) {
        [HUDUtil showErrText:@"请安装微信，QQ或者微博。"];
        return;
    }
    
    [JYZSocialSnsManager showSnsMenu:controller flatforms:snsArr clickHandle:^(id value) {
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

kSynthesizeSingletonForClass(ShareManager)

@end
