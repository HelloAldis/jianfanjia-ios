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

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width completed:(JYZWebImageCompletionBlock)completeBlock {
    [self yy_setImageWithURL:[self imageurl:imageid withWidth:width] placeholder:[UIImage imageNamed:@"image_place_holder"] options:(YYWebImageOptions)JYZWebImageOptionProgressive completion:(YYWebImageCompletionBlock)completeBlock];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width {
    [self yy_setImageWithURL:[self imageurl:imageid withWidth:width] placeholder:[UIImage imageNamed:@"image_place_holder"] options:(YYWebImageOptions)JYZWebImageOptionProgressive completion:nil];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width placeholder:(UIImage *)placeholder {
    [self yy_setImageWithURL:[self imageurl:imageid withWidth:width] placeholder:placeholder options:(YYWebImageOptions)JYZWebImageOptionProgressive completion:nil];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width height:(NSInteger)height {
    [self yy_setImageWithURL:[self imageurl:imageid withWidth:width height:height] placeholder:[UIImage imageNamed:@"image_place_holder"] options:(YYWebImageOptions)JYZWebImageOptionProgressive completion:nil];
}

- (void)setUserImageWithId:(NSString *)imageid {
    [self yy_setImageWithURL:[self imageurl:imageid withWidth:60] placeholder:[UIImage imageNamed:@"image_place_holder_2"] options:(YYWebImageOptions)JYZWebImageOptionProgressive completion:nil];
}

- (void)setUserImageWithId:(NSString *)imageid placeholder:(UIImage *)placeholder {
    [self yy_setImageWithURL:[self imageurl:imageid withWidth:60] placeholder:placeholder options:(YYWebImageOptions)JYZWebImageOptionProgressive completion:nil];
}

- (void)setImageWithId:(NSString *)imageid placeholderImage:(UIImage *)image {
    [self yy_setImageWithURL:[self imageurl:imageid] placeholder:image options:(YYWebImageOptions)JYZWebImageOptionProgressive completion:nil];
}

- (NSURL *)imageurl:(NSString *)imageid {
    NSString *url = [StringUtil rawImageUrl:imageid];
    return [NSURL URLWithString:url];
}

- (NSURL *)imageurl:(NSString *)imageid withWidth:(NSInteger)width {
    NSString *url = [StringUtil thumbnailImageUrl:imageid width:width];
    return [NSURL URLWithString:url];
}

- (NSURL *)imageurl:(NSString *)imageid withWidth:(NSInteger)width height:(NSInteger)height {
    NSString *url = [StringUtil thumbnailImageUrl:imageid width:width height:height];
    return [NSURL URLWithString:url];
}

@end
