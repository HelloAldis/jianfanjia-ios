//
//  LoginBusiness.h
//  jianfanjia
//
//  Created by JYZ on 15/9/15.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginBusiness : NSObject

+ (BOOL)validateLogin:(NSString *)phone pass:(NSString *)pass;

@end
