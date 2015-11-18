//
//  DesignerBusiness.h
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignerBusiness : NSObject

+ (void)setStars:(NSArray *)imageViewArray withStar:(double)star fullStar:(UIImage *)full emptyStar:(UIImage *)empty;
+ (void)setV:(UIImageView *)imageView withAuthType:(NSString *)authType;

@end
