//
//  JYZSocialSnsPlatform.m
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "JYZSocialSnsPlatform.h"

@interface JYZSocialSnsPlatform ()

@end

@implementation JYZSocialSnsPlatform

- (void)login:(UIViewController *)controller compeletion:(JYZLoginCompeletion)completion {
    self.loginCompletion = completion;
    [JYZSocialSnsManager shared].currentSharePlatform = self.socialType;
}

- (void)shareImage:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(JYZShareCompeletion)completion {
    self.shareCompletion = completion;
    [JYZSocialSnsManager shared].currentSharePlatform = self.socialType;
}

- (void)onReceiveResponse:(JYZSocialSnsBaseResp *)resp {
    
}

@end
