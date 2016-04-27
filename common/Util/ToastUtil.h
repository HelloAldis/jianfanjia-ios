//
//  ToastUtil.h
//  jianfanjia
//
//  Created by Karos on 16/4/26.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ToastTapBlock) (NSMutableDictionary *userInfo);

@class Notification;

@interface ToastUtil : NSObject

+ (void)showNotification:(Notification *)notification tapBlock:(ToastTapBlock)tapBlock;

@end
