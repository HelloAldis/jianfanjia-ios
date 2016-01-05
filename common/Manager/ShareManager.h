//
//  ShareManager.h
//  jianfanjia
//
//  Created by Karos on 16/1/5.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginCompeletion)(UMSocialAccountEntity *accountEntity, NSError *error);

@interface ShareManager : NSObject

- (void)share:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink delegate:(id)delegate;


kSynthesizeSingletonForHeader(ShareManager)

@end
