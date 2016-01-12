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
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];

    snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];

            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *responseInfo){
//                    NSLog(@"username is %@, uid is %@, unionid is %@, token is %@ url is %@",snsAccount.userName, snsAccount.usid, snsAccount.unionId, snsAccount.accessToken, snsAccount.iconURL);
//                    NSLog(@"SnsInformation is %@", response.data);
                if (loginCompeletion) {
                    SnsAccountInfo *sns = [[SnsAccountInfo alloc] init];
                    sns.userName = snsAccount.userName;
                    sns.usid = snsAccount.usid;
                    sns.unionId = snsAccount.unionId;
                    sns.iconURL = snsAccount.iconURL;
                    sns.gender = [responseInfo.data[@"gender"] isEqualToNumber:@(0)] ? @"1" : @"0";
                    loginCompeletion(sns, nil);
                }
            }];
            
        } else {
            if (loginCompeletion) {
                loginCompeletion(nil, [@"user cancel the operation" isEqualToString:response.message] ? @"用户取消了操作" : response.message);
            }
        }
    });
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
    
    
    NSMutableArray *snsArr = [NSMutableArray array];
    
    if (kIsInstalledWechat) {
        [snsArr addObject:UMShareToWechatSession];
        [snsArr addObject:UMShareToWechatTimeline];
    }
    
    if (kIsInstalledQQ) {
        [snsArr addObject:UMShareToQQ];
        [snsArr addObject:UMShareToQzone];
    }
    
    if (kIsInstalledWeibo) {
        [snsArr addObject:UMShareToSina];
    }
    
    if (snsArr.count == 0) {
        [HUDUtil showErrText:@"请安装微信，QQ或者微博。"];
        return;
    }
    
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:kUMengAppKey
                                      shareText:description
                                     shareImage:shareImage
                                shareToSnsNames:snsArr
                                       delegate:delegate];
    
    
}

kSynthesizeSingletonForClass(ShareManager)

@end
