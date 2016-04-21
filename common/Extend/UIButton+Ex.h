//
//  UIButton+Ex.h
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (Ex)

@property (strong, nonatomic) NSString *normTitle;
@property (strong, nonatomic) UIColor *normTitleColor;
@property (strong, nonatomic) UIImage *normImg;
@property (strong, nonatomic) UIImage *normBgImg;
@property (strong, nonatomic) UIFont *font;

- (void)disable;
- (void)disable:(NSString *)text;
- (void)enableBgColor:(BOOL)enable;

@end
