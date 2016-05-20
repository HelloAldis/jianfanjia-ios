//
//  DesignerBusiness.h
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductBusiness : NSObject

+ (UIImage *)productAuthTypeImage:(NSString *)authType;
+ (UIColor *)productAuthTypeColor:(NSString *)authType;
+ (UIColor *)productAuthTypeColorByProductCount;

@end
