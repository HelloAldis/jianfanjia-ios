//
//  UIImageView+Ex.h
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JYZWebImageOptions) {
    JYZWebImageOptionProgressive = YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation,
};

/// Indicated where the image came from.
typedef NS_ENUM(NSUInteger, JYZWebImageFromType) {
    
    /// No value.
    JYZWebImageFromNone = 0,
    
    /// Fetched from memory cache immediately.
    /// If you called "setImageWithURL:..." and the image is already in memory,
    /// then you will get this value at the same call.
    JYZWebImageFromMemoryCacheFast,
    
    /// Fetched from memory cache.
    JYZWebImageFromMemoryCache,
    
    /// Fetched from disk cache.
    JYZWebImageFromDiskCache,
    
    /// Fetched from remote (web or file path).
    JYZWebImageFromRemote,
};

/// Indicated image fetch complete stage.
typedef NS_ENUM(NSInteger, JYZWebImageStage) {
    
    /// Incomplete, progressive image.
    JYZWebImageStageProgress  = -1,
    
    /// Cancelled.
    JYZWebImageStageCancelled = 0,
    
    /// Finished (succeed or failed).
    JYZWebImageStageFinished  = 1,
};

/**
 The block invoked when image fetch finished or cancelled.
 
 @param image       The image.
 @param url         The image url (remote or local file path).
 @param from        Where the image came from.
 @param error       Error during image fetching.
 @param finished    If the operation is cancelled, this value is NO, otherwise YES.
 */
typedef void (^JYZWebImageCompletionBlock)(UIImage *image, NSURL *url, JYZWebImageFromType from, JYZWebImageStage stage, NSError *error);

/**
 The block invoked in remote image fetch progress.
 
 @param receivedSize Current received size in bytes.
 @param expectedSize Expected total size in bytes (-1 means unknown).
 */
typedef void(^JYZWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

/**
 The block invoked before remote image fetch finished to do additional image process.
 
 @discussion This block will be invoked before `YYWebImageCompletionBlock` to give
 you a chance to do additional image process (such as resize or crop). If there's
 no need to transform the image, just return the `image` parameter.
 
 @example You can clip the image, blur it and add rounded corners with these code:
 ^(UIImage *image, NSURL *url) {
 // Maybe you need to create an @autoreleasepool to limit memory cost.
 image = [image yy_imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeScaleAspectFill];
 image = [image yy_imageByBlurRadius:20 tintColor:nil tintMode:kCGBlendModeNormal saturation:1.2 maskImage:nil];
 image = [image yy_imageByRoundCornerRadius:5];
 return image;
 }
 
 @param image The image fetched from url.
 @param url   The image url (remote or local file path).
 @return The transformed image.
 */
typedef UIImage * (^JYZWebImageTransformBlock)(UIImage *image, NSURL *url);


@interface UIImageView (Ex)

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width placeholder:(UIImage *)placeholder options:(JYZWebImageOptions)options progress:(JYZWebImageProgressBlock)progress completed:(JYZWebImageCompletionBlock)completeBlock;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width completed:(JYZWebImageCompletionBlock)completeBlock;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width placeholder:(UIImage *)placeholder;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width height:(NSInteger)height;
- (void)setUserImageWithId:(NSString *)imageid;
- (void)setUserImageWithId:(NSString *)imageid placeholder:(UIImage *)placeholder;
- (void)setImageWithId:(NSString *)imageid placeholder:(UIImage *)placeholder;

- (void)cancelCurrentImageRequest;

@end
