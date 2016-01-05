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
    if (![UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToWechatSession]) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];

        snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            }
        });
    }
}

- (void)share:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink delegate:(id)delegate {
    [UMSocialData defaultData].extConfig.wechatSessionData.url = targetLink;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = targetLink;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.qqData.url = targetLink;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qzoneData.url = targetLink;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:kUMengAppKey
                                      shareText:description
                                     shareImage:shareImage
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                       delegate:delegate];
}

kSynthesizeSingletonForClass(ShareManager)

@end
