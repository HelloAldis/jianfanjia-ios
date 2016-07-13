//
//  AlertUtil.h
//  jianfanjia
//
//  Created by Karos on 16/7/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertUtil : NSObject

+ (void)show:(UIViewController *)controller title:(NSString *)title doneBlock:(void(^)(void))doneBlock;
+ (void)show:(UIViewController *)controller title:(NSString *)title cancelBlock:(void(^)(void))cancelBlock doneBlock:(void(^)(void))doneBlock;
+ (void)show:(UIViewController *)controller title:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText cancelBlock:(void(^)(void))cancelBlock doneText:(NSString *)doneText doneBlock:(void(^)(void))doneBlock completion:(void(^)(void))completion;

@end
