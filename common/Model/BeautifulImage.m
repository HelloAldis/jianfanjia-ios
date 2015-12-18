//
//  BeautifulImage.m
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BeautifulImage.h"
#import "LeafImage.h"

@implementation BeautifulImage

@dynamic _id;
@dynamic title;
@dynamic house_type;
@dynamic dec_style;
@dynamic images;

- (LeafImage *)leafImageAtIndex:(NSInteger )index {
    if (index >= 0 && index < self.images.count) {
        NSMutableDictionary *dict = [self.images objectAtIndex:index];
        return [[LeafImage alloc] initWith:dict];
    } else {
        return nil;
    }
}

@end
