//
//  DesignerPageData.m
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerPageData.h"

@implementation DesignerPageData

- (DesignerPageData *)refreshDesigner {
    NSMutableDictionary *dict = [DataManager shared].data;
    self.designer = [[Designer alloc] initWith:dict];
    return self;
}

- (NSInteger)refreshProduct {
    NSArray* arr = [[DataManager shared].data objectForKey:@"products"];
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [products addObject:[[Product alloc] initWith:dict]];
    }
    
    self.products = products;
    return products.count;
}

- (NSInteger)loadMoreProduct {
    NSArray* arr = [[DataManager shared].data objectForKey:@"products"];
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [products addObject:[[Product alloc] initWith:dict]];
    }
    
    [self.products addObjectsFromArray:products];
    return products.count;
}

@end
