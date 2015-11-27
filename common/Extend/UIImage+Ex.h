//
//  UIImage+Ex.h
//  jianfanjia
//
//  Created by JYZ on 15/11/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ex)

- (NSData *)data;
- (UIImage *)getCenterSquareImage;
- (UIImage *)getSubImage:(CGRect)rect;

@end
