//
//  Product.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Product.h"

@implementation Product

@dynamic _id;
@dynamic designerid;
@dynamic province;
@dynamic city;
@dynamic district;
@dynamic cell;
@dynamic house_type;
@dynamic business_house_type;
@dynamic dec_type;
@dynamic house_area;
@dynamic dec_style;
@dynamic auth_type;
@dynamic work_type;
@dynamic total_price;
@dynamic product_description;
@dynamic cover_imageid;
@dynamic plan_images;
@dynamic images;
@dynamic is_my_favorite;
@dynamic is_deleted;

- (void)setObject:(id)o forKey:(NSString *)key {
    if ([@"product_description" isEqualToString:key]) {
        [[self data] setObject:o forKey:@"description"];
    } else {
        [[self data] setObject:o forKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    if ([@"product_description" isEqualToString:key]) {
        return [[self data] objectForKey:@"description"];
    } else {
        return [[self data] objectForKey:key];
    }
}

- (ProductImage *)planImageAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.plan_images.count) {
        NSMutableDictionary *dict = [self.plan_images objectAtIndex:index];
        return [[ProductImage alloc] initWith:dict];
    } else {
        return nil;
    }
}

- (ProductImage *)imageAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.images.count) {
        NSMutableDictionary *dict = [self.images objectAtIndex:index];
        return [[ProductImage alloc] initWith:dict];
    } else {
        return nil;
    }
}

@end


