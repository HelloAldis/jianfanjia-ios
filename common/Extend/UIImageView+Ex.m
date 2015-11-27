//
//  UIImageView+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "UIImageView+Ex.h"
#import "API.h"

@implementation UIImageView (Ex)

- (void)setImageWithId:(NSString *)imageid {
    [self sd_setImageWithURL:[self imageurl:imageid] placeholderImage:[UIImage imageNamed:@"image_place_holder"]];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width {
    [self sd_setImageWithURL:[self imageurl:imageid withWidth:width] placeholderImage:[UIImage imageNamed:@"image_place_holder"]];
}

- (void)setUserImageWithId:(NSString *)imageid {
    [self sd_setImageWithURL:[self imageurl:imageid withWidth:60] placeholderImage:[UIImage imageNamed:@"image_place_holder_2"]];
}

- (void)setImageWithId:(NSString *)imageid placeholderImage:(UIImage *)image {
    [self sd_setImageWithURL:[self imageurl:imageid] placeholderImage:image];
}

- (NSURL *)imageurl:(NSString *)imageid {
    NSString *url = [NSString stringWithFormat:@"%@image/%@", kApiUrl, imageid];
    return [NSURL URLWithString:url];
}

- (NSURL *)imageurl:(NSString *)imageid withWidth:(long)width {    
    width = width * kScreenScale;
    NSString *url = [NSString stringWithFormat:@"%@thumbnail/%ld/%@", kApiUrl, width ,imageid];
    return [NSURL URLWithString:url];
}

@end
