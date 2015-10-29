//
//  Product.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Product.h"

@implementation Product

@dynamic province;
@dynamic city;
@dynamic district;
@dynamic cell;
@dynamic house_type;
@dynamic dec_type;
@dynamic house_area;
@dynamic dec_style;
@dynamic work_type;
@dynamic total_price;
@dynamic description;
@dynamic images;

- (ProductImage *)imageAtIndex:(NSInteger )index {
    if (index >= 0 && index < self.images.count) {
        NSMutableDictionary *dict = [self.images objectAtIndex:index];
        return [[ProductImage alloc] initWith:dict];
    } else {
        return nil;
    }
}

@end


