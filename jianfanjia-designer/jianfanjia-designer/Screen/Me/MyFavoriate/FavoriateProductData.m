//
//  FavoriateProductData.m
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FavoriateProductData.h"

@implementation FavoriateProductData

- (NSInteger)refreshProduct {
    NSArray* arr = [[DataManager shared].data objectForKey:@"products"];
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [products addObject:[[Product alloc] initWith:dict]];
    }
    
    self.products = products;
    return [products count];
}

- (NSInteger)loadMoreProduct {
    NSArray* arr = [[DataManager shared].data objectForKey:@"products"];
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [products addObject:[[Product alloc] initWith:dict]];
    }
    
    [self.products addObjectsFromArray:products];
    return [products count];
}

@end
