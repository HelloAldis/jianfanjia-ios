//
//  PriceItem.m
//  jianfanjia
//
//  Created by Karos on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PriceItem.h"

@implementation PriceItem

@dynamic _id;
@dynamic item;
@dynamic price_description;
@dynamic price;

- (void)setObject:(id)o forKey:(NSString *)key {
    if ([@"price_description" isEqualToString:key]) {
        [[self data] setObject:o forKey:@"description"];
    } else {
        [[self data] setObject:o forKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    if ([@"price_description" isEqualToString:key]) {
        return [[self data] objectForKey:@"description"];
    } else {
        return [[self data] objectForKey:key];
    }
}

@end
