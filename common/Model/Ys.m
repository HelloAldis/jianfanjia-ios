//
//  Ys.m
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Ys.h"

@implementation Ys

@dynamic date;
@dynamic images;

- (YsImage *)ysImageAtIndex:(NSInteger )index {
    if (index >= 0 && index < self.images.count) {
        NSMutableDictionary *dict = [self.images objectAtIndex:index];
        return [[YsImage alloc] initWith:dict];
    } else {
        return nil;
    }
}

@end
