//
//  FavoriteDesignerData.m
//  jianfanjia
//
//  Created by JYZ on 15/11/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FavoriteDesignerData.h"

@implementation FavoriteDesignerData

- (NSInteger)refreshDesigner {
    NSArray* arr = [[DataManager shared].data objectForKey:@"designers"];
    NSMutableArray *designers = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [designers addObject:[[Designer alloc] initWith:dict]];
    }
    
    self.designers = designers;
    return [designers count];
}

- (NSInteger)loadMoreDesigner {
    NSArray* arr = [[DataManager shared].data objectForKey:@"designers"];
    NSMutableArray *designers = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [designers addObject:[[Designer alloc] initWith:dict]];
    }
    
    [self.designers addObjectsFromArray:designers];
    return [designers count];
}

@end
