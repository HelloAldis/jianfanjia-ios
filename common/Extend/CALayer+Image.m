//
//  CALayer+Ex.m
//  jianfanjia
//
//  Created by Karos on 16/2/24.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "CALayer+Image.h"

@implementation CALayer (Image)

- (void)setImageWithImgURL:(NSURL *)imageidUrl placeholder:(UIImage *)placeholder options:(JYZWebImageOptions)options progress:(JYZWebImageProgressBlock)progress transform:(JYZWebImageTransformBlock)transform completed:(JYZWebImageCompletionBlock)completeBlock {
    [self yy_setImageWithURL:imageidUrl placeholder:placeholder options:(YYWebImageOptions)options progress:(YYWebImageProgressBlock)progress transform:transform completion:(YYWebImageCompletionBlock)completeBlock];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width height:(NSInteger)height placeholder:(UIImage *)placeholder options:(JYZWebImageOptions)options progress:(JYZWebImageProgressBlock)progress transform:(JYZWebImageTransformBlock)transform completed:(JYZWebImageCompletionBlock)completeBlock {
    NSURL *url = nil;
    if (width > 0 && height > 0) {
        url = [self imageurl:imageid withWidth:width height:height];
    } else if (width > 0) {
        url = [self imageurl:imageid withWidth:width];
    } else {
        url = [self imageurl:imageid];
    }
    
    [self setImageWithImgURL:url placeholder:placeholder options:options progress:progress transform:transform completed:completeBlock];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width placeholder:(UIImage *)placeholder options:(JYZWebImageOptions)options progress:(JYZWebImageProgressBlock)progress completed:(JYZWebImageCompletionBlock)completeBlock {
    [self setImageWithId:imageid withWidth:width height:0 placeholder:placeholder options:(JYZWebImageOptions)options progress:(JYZWebImageProgressBlock)progress transform:nil completed:(JYZWebImageCompletionBlock)completeBlock];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width placeholder:(UIImage *)placeholder progress:(JYZWebImageProgressBlock)progress completed:(JYZWebImageCompletionBlock)completeBlock {
    [self setImageWithId:imageid withWidth:width height:0 placeholder:placeholder options:(JYZWebImageOptions)JYZWebImageOptionProgressive progress:(JYZWebImageProgressBlock)progress transform:nil completed:(JYZWebImageCompletionBlock)completeBlock];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width completed:(JYZWebImageCompletionBlock)completeBlock {
    [self setImageWithId:imageid withWidth:width height:0 placeholder:[UIImage imageNamed:@"image_place_holder"] options:(JYZWebImageOptions)JYZWebImageOptionProgressive progress:nil transform:nil completed:(JYZWebImageCompletionBlock)completeBlock];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width {
    [self setImageWithId:imageid withWidth:width height:0 placeholder:[UIImage imageNamed:@"image_place_holder"] options:(JYZWebImageOptions)JYZWebImageOptionProgressive progress:nil transform:nil completed:nil];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width placeholder:(UIImage *)placeholder {
    [self setImageWithId:imageid withWidth:width height:0 placeholder:placeholder options:(JYZWebImageOptions)JYZWebImageOptionProgressive progress:nil transform:nil completed:nil];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width placeholder:(UIImage *)placeholder completed:(JYZWebImageCompletionBlock)completeBlock {
    [self setImageWithId:imageid withWidth:width height:0 placeholder:placeholder options:(JYZWebImageOptions)JYZWebImageOptionProgressive progress:nil transform:nil completed:(JYZWebImageCompletionBlock)completeBlock];
}

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width height:(NSInteger)height {
    [self setImageWithId:imageid withWidth:width height:height placeholder:[UIImage imageNamed:@"image_place_holder"] options:(JYZWebImageOptions)JYZWebImageOptionProgressive progress:nil transform:nil completed:nil];
}

- (void)setUserImageWithId:(NSString *)imageid {
    [self setUserImageWithId:imageid placeholder:[UIImage imageNamed:@"image_place_holder_2"]];
}

- (void)setUserImageWithId:(NSString *)imageid placeholder:(UIImage *)placeholder {
    [self setImageWithId:imageid withWidth:60 height:0 placeholder:placeholder options:(JYZWebImageOptions)JYZWebImageOptionProgressive progress:nil transform:^UIImage *(UIImage *image, NSURL *url) {
        return [image imageByRoundCornerRadius:image.size.height / 2.0 backgroundColor:[UIColor whiteColor]];
    } completed:nil];
}

- (void)setImageWithId:(NSString *)imageid placeholder:(UIImage *)placeholder {
    [self setImageWithId:imageid withWidth:0 height:0 placeholder:placeholder options:(JYZWebImageOptions)JYZWebImageOptionProgressive progress:nil transform:nil completed:nil];
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

- (void)cancelCurrentImageRequest {
    [self yy_cancelCurrentImageRequest];
}

@end
