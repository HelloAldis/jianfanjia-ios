//
//  ShareBusiness.h
//  jianfanjia
//
//  Created by Karos on 16/1/4.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareBusiness : NSObject

+ (void)share:(UIViewController *)controller image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink delegate:(id)delegate;

@end
