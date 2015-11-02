//
//  UIColor+Ex.m
//  jianfanjia
//
//  Created by Karos on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UIColor+Ex.h"

@implementation UIColor (Ex)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

@end
