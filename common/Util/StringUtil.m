//
//  StringUtil.m
//  jianfanjia
//
//  Created by JYZ on 15/12/4.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

+ (NSString *)convertNil2Empty:(NSString *)aStr {
    return aStr ? aStr : @"";
}

+ (NSString *)rawImageUrl:(NSString *)imageid {
    NSString *url = [NSString stringWithFormat:@"%@image/%@", kApiUrl, imageid];
    return url;
}

+ (NSString *)thumbnailImageUrl:(NSString *)imageid width:(NSInteger)width {
    width = width * kScreenScale;
    NSString *url = [NSString stringWithFormat:@"%@thumbnail/%@/%@", kApiUrl, [NSNumber numberWithInteger:width] ,imageid];
    return url;
}

@end
