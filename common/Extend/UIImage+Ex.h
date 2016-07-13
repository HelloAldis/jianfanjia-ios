//
//  UIImage+Ex.h
//  jianfanjia
//
//  Created by JYZ on 15/11/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef YY_CLAMP // return the clamped value
#define YY_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

#ifndef YY_SWAP // swap two value
#define YY_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif

@interface UIImage (Ex)

- (NSData *)data;
- (UIImage *)getCenterSquareImage;
- (UIImage *)getSubImage:(CGRect)rect;
- (UIImage *)aspectToScale:(float)scaleWidth;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)imageByGrayscale;
- (UIImage *)imageByBlurSoft;
- (UIImage *)imageByBlurLight;
- (UIImage *)imageByBlurExtraLight;
- (UIImage *)imageByBlurDark;
- (UIImage *)imageByBlurRadius:(CGFloat)blurRadius
                     tintColor:(UIColor *)tintColor
                      tintMode:(CGBlendMode)tintBlendMode
                    saturation:(CGFloat)saturation
                     maskImage:(UIImage *)maskImage;
/**
 Draws the entire image in the specified rectangle, content changed with
 the contentMode.
 
 @discussion This method draws the entire image in the current graphics context,
 respecting the image's orientation setting. In the default coordinate system,
 images are situated down and to the right of the origin of the specified
 rectangle. This method respects any transforms applied to the current graphics
 context, however.
 
 @param rect        The rectangle in which to draw the image.
 
 @param contentMode Draw content mode
 
 @param clips       A Boolean value that determines whether content are confined to the rect.
 */
- (void)drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clips;
@end
