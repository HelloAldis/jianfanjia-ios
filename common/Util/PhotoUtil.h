//
//  PhotoUtil.h
//  jianfanjia
//
//  Created by Karos on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageBrowerViewController.h"

@interface PhotoUtil : NSObject

+ (void)showUserAvatarSelector;
+ (void)showDecorationNodeImageSelector:(NSInteger)count withBlock:(FinishUploadBlock)block;

@end
