//
//  ProductImage.m
//  jianfanjia
//
//  Created by JYZ on 15/10/29.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductImage.h"

@implementation ProductImage

@dynamic imageid;
@dynamic section;
@dynamic productImage_description;

- (void)setObject:(id)o forKey:(NSString *)key {
    if ([@"productImage_description" isEqualToString:key]) {
        [[self data] setObject:o forKey:@"description"];
    } else {
        [[self data] setObject:o forKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    if ([@"productImage_description" isEqualToString:key]) {
        return [[self data] objectForKey:@"description"];
    } else {
        return [[self data] objectForKey:key];
    }
}

@end
