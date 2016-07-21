//
//  CALayer+Ex.h
//  jianfanjia
//
//  Created by Karos on 16/2/24.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Image)

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width placeholder:(UIImage *)placeholder options:(JYZWebImageOptions)options progress:(JYZWebImageProgressBlock)progress completed:(JYZWebImageCompletionBlock)completeBlock;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width completed:(JYZWebImageCompletionBlock)completeBlock;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width placeholder:(UIImage *)placeholder;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width placeholder:(UIImage *)placeholder completed:(JYZWebImageCompletionBlock)completeBlock;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width height:(NSInteger)height;
- (void)setUserImageWithId:(NSString *)imageid;
- (void)setUserImageWithId:(NSString *)imageid placeholder:(UIImage *)placeholder;
- (void)setImageWithId:(NSString *)imageid placeholder:(UIImage *)placeholder;

- (void)cancelCurrentImageRequest;

@end
