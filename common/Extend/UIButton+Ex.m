
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

- (void)setImageWithId:(NSString *)imageid placeholderImage:(UIImage *)image {
    [self sd_setImageWithURL:[self imageurl:imageid] forState:UIControlStateNormal placeholderImage:image];
}

- (NSURL *)imageurl:(NSString *)imageid {
    NSString *url = [NSString stringWithFormat:@"%@image/%@", kApiUrl, imageid];
    return [NSURL URLWithString:url];
}

@end
