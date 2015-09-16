//
//  UIImageView+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "UIImageView+Ex.h"
#import "API.h"

@implementation UIImageView (Ex)

- (void)setImageWithId:(NSString *)imageid {
    [self sd_setImageWithURL:[self imageurl:imageid]];
}

- (NSURL *)imageurl:(NSString *)imageid {
    NSString *url = [NSString stringWithFormat:@"%@image/%@", API_URL, imageid];
    return [NSURL URLWithString:url];
}

@end
