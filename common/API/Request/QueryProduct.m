//
//  QueryProduct.m
//  jianfanjia
//
//  Created by JYZ on 15/11/6.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "QueryProduct.h"

@implementation QueryProduct

@dynamic query;
@dynamic from;
@dynamic limit;

- (void)success {
    NSArray* arr = [[DataManager shared].data objectForKey:@"products"];
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [products addObject:[[Product alloc] initWith:dict]];
    }
    
    if (self.from.integerValue == 0) {
        [DataManager shared].designerPageProducts = products;
    } else {
        [[DataManager shared].designerPageProducts addObjectsFromArray:products];
    }
}

@end
