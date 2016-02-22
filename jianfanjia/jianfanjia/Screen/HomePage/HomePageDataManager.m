//
//  HomePageDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/19.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "HomePageDataManager.h"

@implementation HomePageDataManager

- (void)refresh {
    NSArray* arr = [DataManager shared].data;
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [products addObject:[[Product alloc] initWith:dict]];
    }
    
    self.homeProducts = products;
}

@end
