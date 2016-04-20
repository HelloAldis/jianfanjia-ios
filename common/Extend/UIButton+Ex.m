
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

#pragma mark - property
- (NSString *)normTitle {
    return [self titleForState:UIControlStateNormal];
}

- (void)setNormTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (UIColor *)normTitleColor {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setNormTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (UIImage *)normImg {
    return [self imageForState:UIControlStateNormal];
}

- (void)setNormImg:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (UIImage *)normBgImg {
    return [self backgroundImageForState:UIControlStateNormal];
}

- (void)setNormBgImg:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (UIColor *)bgColor {
    return self.backgroundColor;
}

- (void)setBgColor:(UIColor *)color {
    [self setBackgroundColor:color];
}

- (UIFont *)font {
    return self.titleLabel.font;
}

- (void)setFont:(UIFont *)font {
    [self.titleLabel setFont:font];
}

@end
