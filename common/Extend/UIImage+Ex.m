//
//  UIImage+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/11/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UIImage+Ex.h"

@implementation UIImage (Ex)

- (NSData *)data {
    NSData *data = UIImageJPEGRepresentation(self, 0.9);
//    if (self.size.width > 640) {
//        CGRect rect = CGRectMake(0, 0, 640, 640);
//        UIGraphicsBeginImageContext(rect.size);
//        [self drawInRect:rect];
//        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        data = UIImageJPEGRepresentation(img, 0.7);
//    } else {
//        data = UIImageJPEGRepresentation(self, 0.7);
//    }
    
    DDLogDebug(@"data bytes %d", (int)[data length]);
    
    return data;
}

- (UIImage *)getSubImage:(CGRect)rect {
    UIImage *image = [self fixOrientation];
    DDLogDebug(@"%@", NSStringFromCGRect(rect));
    
    CGImageRef cImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *smallImage = [UIImage imageWithCGImage:cImage scale:self.scale orientation:UIImageOrientationUp];
    CGImageRelease(cImage);
    
    DDLogDebug(@"%ld", (long)smallImage.imageOrientation);
    DDLogDebug(@"%@", NSStringFromCGSize(smallImage.size));
    return smallImage;
}

- (UIImage *)getSquareImage {
    CGFloat height = self.size.height;
    CGFloat width = self.size.width;
    
    if (fabs(height - width) < 0.01) {
        return self;
    }
    
    CGFloat square = height > width ? width : height;
    
    return [self getSubImage:CGRectMake(0, 0, square, square)];
}

- (UIImage *)getCenterSquareImage {
    CGFloat height = self.size.height;
    CGFloat width = self.size.width;
    
    if (fabs(height - width) < 0.01) {
        return self;
    }
    
    if (height > width) {
        float y = (height - width) / 2.0;
        return [self getSubImage:CGRectMake(0, y, width, width)];
    } else {
        float x = (width - height) / 2.0;
        return [self getSubImage:CGRectMake(x, 0, height, height)];
    }
}

- (UIImage *)aspectToScale:(CGFloat)scaleWidth {
    CGFloat oldWidth = self.size.width;
    CGFloat scaleFactor = scaleWidth / oldWidth;
    
    CGFloat newWidth = oldWidth * scaleFactor;
    CGFloat newHeight = self.size.height * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
