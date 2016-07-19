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

/// Convert degrees to radians.
static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

/// Convert radians to degrees.
static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

@interface UIImage (Ex)

- (NSData *)data;
- (UIImage *)getOpaqueImage;
- (UIImage *)getCenterSquareImage;
- (UIImage *)getSubImage:(CGRect)rect;
- (UIImage *)aspectToScale:(CGFloat)scaleWidth;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)imageByGrayscale;
- (UIImage *)imageByBlurSoft;
- (UIImage *)imageByBlurLight;
- (UIImage *)imageByBlurExtraLight;
- (UIImage *)imageByBlurDark;

/**
 Applies a blur, tint color, and saturation adjustment to this image,
 optionally within the area specified by @a maskImage.
 
 @param blurRadius     The radius of the blur in points, 0 means no blur effect.
 
 @param tintColor      An optional UIColor object that is uniformly blended with
 the result of the blur and saturation operations. The
 alpha channel of this color determines how strong the
 tint is. nil means no tint.
 
 @param tintBlendMode  The @a tintColor blend mode. Default is kCGBlendModeNormal (0).
 
 @param saturation     A value of 1.0 produces no change in the resulting image.
 Values less than 1.0 will desaturation the resulting image
 while values greater than 1.0 will have the opposite effect.
 0 means gray scale.
 
 @param maskImage      If specified, @a inputImage is only modified in the area(s)
 defined by this mask.  This must be an image mask or it
 must meet the requirements of the mask parameter of
 CGContextClipToMask.
 
 @return               image with effect, or nil if an error occurs (e.g. no
 enough memory).
 */
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

/**
 Returns a new image which is scaled from this image.
 The image will be stretched as needed.
 
 @param size  The new size to be scaled, values should be positive.
 
 @return      The new image with the given size.
 */
- (UIImage *)imageByResizeToSize:(CGSize)size;

/**
 Returns a new image which is scaled from this image.
 The image content will be changed with thencontentMode.
 
 @param size        The new size to be scaled, values should be positive.
 
 @param contentMode The content mode for image content.
 
 @return The new image with the given size.
 */
- (UIImage *)imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/**
 Returns a new image which is cropped from this image.
 
 @param rect  Image's inner rect.
 
 @return      The new image, or nil if an error occurs.
 */
- (UIImage *)imageByCropToRect:(CGRect)rect;

/**
 Returns a new image which is edge inset from this image.
 
 @param insets  Inset (positive) for each of the edges, values can be negative to 'outset'.
 
 @param color   Extend edge's fill color, nil means clear color.
 
 @return        The new image, or nil if an error occurs.
 */
- (UIImage *)imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color;

/**
 Rounds a new image with a given corner size.
 
 @param radius  The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to half
 the width or height.
 */
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor;

/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.
 
 @param borderColor  The border stroke color. nil means clear color.
 */
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(UIColor *)borderColor;

/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.
 
 @param corners      A bitmask value that identifies the corners that you want
 rounded. You can use this parameter to round only a subset
 of the corners of the rectangle.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.
 
 @param borderColor  The border stroke color. nil means clear color.
 
 @param borderLineJoin The border line join.
 */
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                                       corners:(UIRectCorner)corners
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(UIColor *)borderColor
                                borderLineJoin:(CGLineJoin)borderLineJoin;

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                      backgroundColor:(UIColor *)backgroundColor
                               opaque:(BOOL)opaque
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;

/**
 Returns a new rotated image (relative to the center).
 
 @param radians   Rotated radians in counterclockwise.⟲
 
 @param fitSize   YES: new image's size is extend to fit all content.
 NO: image's size will not change, content may be clipped.
 */
- (UIImage *)imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/**
 Returns a new image rotated counterclockwise by a quarter‑turn (90°). ⤺
 The width and height will be exchanged.
 */
- (UIImage *)imageByRotateLeft90;

/**
 Returns a new image rotated clockwise by a quarter‑turn (90°). ⤼
 The width and height will be exchanged.
 */
- (UIImage *)imageByRotateRight90;

/**
 Returns a new image rotated 180° . ↻
 */
- (UIImage *)imageByRotate180;

/**
 Returns a vertically flipped image. ⥯
 */
- (UIImage *)imageByFlipVertical;

/**
 Returns a horizontally flipped image. ⇋
 */
- (UIImage *)imageByFlipHorizontal;

@end
