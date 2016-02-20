//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DesignerListDataManager.h"

@implementation DesignerListDataManager

- (NSInteger)refresh {
    NSArray* arr = [[DataManager shared].data objectForKey:@"designers"];
    NSMutableArray *designers = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Designer *designer = [[Designer alloc] initWith:dict];
        [designers addObject:designer];
    }
    
    self.designers = designers;
    return designers.count;
}

- (NSInteger)loadMore {
    NSArray* arr = [[DataManager shared].data objectForKey:@"designers"];
    NSMutableArray *designers = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Designer *designer = [[Designer alloc] initWith:dict];
        [designers addObject:designer];
    }
    
    [self.designers addObjectsFromArray:designers];
    return designers.count;
}

@end
