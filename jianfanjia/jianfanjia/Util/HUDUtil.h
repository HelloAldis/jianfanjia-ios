//
//  HUDUtil.h
//  jianfanjia
//
//  Created by JYZ on 15/9/15.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDUtil : NSObject

+ (void)showErrText:(NSString *) text;
+ (void)showSuccessText:(NSString *) text;
+ (void)showWait;
+ (void)hideWait;

@end
