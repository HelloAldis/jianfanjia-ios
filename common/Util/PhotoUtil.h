//
//  PhotoUtil.h
//  jianfanjia
//
//  Created by Karos on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoUtil : NSObject

+ (void)showUserAvatarSelector:(nonnull UIViewController *)controller inView:(nullable UIView *)sourceView withBlock:(nullable FinishUploadBlock)block;
+ (void)showDecorationNodeImageSelector:(nonnull UIViewController *)controller inView:(nullable UIView *)sourceView max:(NSInteger)count withBlock:(nullable FinishUploadBlock)block;
+ (void)showUploadProductImageSelector:(nonnull UIViewController *)controller inView:(nullable UIView *)sourceView max:(NSInteger)count withBlock:(nullable FinishUploadBlock)block;

@end
