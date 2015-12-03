//
//  UIImageView+Ex.h
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView (Ex)

- (void)setImageWithProgress:(NSString *)imageid placeholderImage:(UIImage *)image;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width;
- (void)setUserImageWithId:(NSString *)imageid;
- (void)setImageWithId:(NSString *)imageid placeholderImage:(UIImage *)image;

@end
