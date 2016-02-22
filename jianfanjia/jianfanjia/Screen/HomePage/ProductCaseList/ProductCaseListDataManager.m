//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductCaseListDataManager.h"

@implementation ProductCaseListDataManager

- (NSInteger)refresh {
    NSArray* arr = [[DataManager shared].data objectForKey:@"products"];
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Product *product = [[Product alloc] initWith:dict];
        product.designer = [[Designer alloc] initWith:[product.data objectForKey:@"designer"]];
        [products addObject:product];
    }
    
    self.products = products;
    return products.count;
}

- (NSInteger)loadMore {
    NSArray* arr = [[DataManager shared].data objectForKey:@"products"];
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Product *product = [[Product alloc] initWith:dict];
        product.designer = [[Designer alloc] initWith:[product.data objectForKey:@"designer"]];
        [products addObject:product];
    }
    
    [self.products addObjectsFromArray:products];
    return products.count;
}

@end
