//
//  AccountBusiness.h
//  jianfanjia
//
//  Created by JYZ on 15/10/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountBusiness : NSObject

+ (BOOL)validateLogin:(NSString *)phone pass:(NSString *)pass;
+ (UIImage *)defaultAvatar;

@end
