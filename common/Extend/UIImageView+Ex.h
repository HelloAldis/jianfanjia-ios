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

@interface UIImageView (Ex)

- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width completed:(JYZWebImageCompletionBlock)completeBlock;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width;
- (void)setImageWithId:(NSString *)imageid withWidth:(NSInteger)width height:(NSInteger)height;
- (void)setUserImageWithId:(NSString *)imageid;
- (void)setUserImageWithId:(NSString *)imageid placeholder:(UIImage *)placeholder;
- (void)setImageWithId:(NSString *)imageid placeholderImage:(UIImage *)image;

@end
