
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
    [self setNormTitleColor:[UIColor whiteColor]];
    [self setBgColor:kUntriggeredColor];
    if (text) {
        [self setNormTitle:text];
    }

    [self setEnabled:NO];
}

- (void)enableBgColor:(BOOL)enable {
    self.enabled = enable;
    [self setBgColor:enable ? kThemeColor : kUntriggeredColor];
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

- (UIFont *)font {
    return self.titleLabel.font;
}

- (void)setFont:(UIFont *)font {
    [self.titleLabel setFont:font];
}

@end
