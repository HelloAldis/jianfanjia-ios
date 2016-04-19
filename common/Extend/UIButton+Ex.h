//
//  UIButton+Ex.h
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (Ex)

- (void)disable;
- (void)disable:(NSString *)text;
- (void)enableBgColor:(BOOL)enable;
- (void)setNormTitle:(NSString *)title;
- (void)setNormColor:(UIColor *)color;
- (void)setNormImg:(UIImage *)image;
- (void)setNormBgImg:(UIImage *)image;
- (void)setBgColor:(UIColor *)color;
- (void)setFont:(UIFont *)font;

@end
