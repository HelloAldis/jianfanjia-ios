//
//  UIView+Util.h
//  AURA
//
//  Created by KindAzrael on 15/3/8.
//  Copyright (c) 2015年 AURA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Ex)

- (void)setCornerRadius:(CGFloat)radius;
- (void)setBorder:(CGFloat)width andColor:(CGColorRef)color;
- (UIView *)getFirstResponder;

@end
