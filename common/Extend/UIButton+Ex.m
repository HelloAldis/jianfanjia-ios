
//
//  UIButton+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "UIButton+Ex.h"
#import "API.h"

@implementation UIButton (Ex)

- (void)disable {
    [self disable:nil];
}

- (void)disable:(NSString *)text {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundColor:kUntriggeredColor];
    if (text) {
        [self setTitle:text forState:UIControlStateNormal];
    }

    [self setEnabled:NO];
}

- (void)enableBgColor:(BOOL)enable {
    self.enabled = enable;
    [self setBackgroundColor:enable ? kThemeColor : kUntriggeredColor];
}

- (void)setNormTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setNormColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setNormImg:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setNormBgImg:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setBgColor:(UIColor *)color {
    [self setBackgroundColor:color];
}

- (void)setFont:(UIFont *)font {
    [self.titleLabel setFont:font];
}

@end
