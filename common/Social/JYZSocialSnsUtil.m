//
//  JYZSocialUtil.m
//  jianfanjia
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "JYZSocialSnsUtil.h"

@implementation JYZSocialSnsUtil

+ (UIImage *)thumbnailWithImage:(UIImage *)image {
    CGFloat thumbnailWidth = 150;
    UIImage *newimage;
    
    if (nil == image) {
        newimage = nil;
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(thumbnailWidth, thumbnailWidth));
        [image drawInRect:CGRectMake(0, 0, thumbnailWidth, thumbnailWidth)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    return newimage;
}

@end
