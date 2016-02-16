//
//  BeautifulImagePosition.m
//  jianfanjia
//
//  Created by Karos on 16/2/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BeautifulImagePosition.h"

@implementation BeautifulImagePosition

@dynamic beautiful_images;
@dynamic total;

- (BeautifulImage *)beautifulImageAtIndex:(NSInteger )index {
    if (index >= 0 && index < self.beautiful_images.count) {
        NSMutableDictionary *dict = [self.beautiful_images objectAtIndex:index];
        return [[BeautifulImage alloc] initWith:dict];
    } else {
        return nil;
    }
}

@end
