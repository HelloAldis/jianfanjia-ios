//
//  RequirementListData.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementDataManager.h"

@implementation RequirementDataManager

- (void)refreshRequirementList {
    NSArray* arr = [DataManager shared].data;
    NSMutableArray *requirements = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [requirements addObject:[[Requirement alloc] initWith:dict]];
    }
    
    self.requirements = requirements;
    
}

- (void)refreshOrderedDesigners:(Requirement *)requirement {
    NSArray *arr = [requirement.data objectForKey:@"order_designers"];
    NSMutableArray *orderedDesigners = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Designer *orderedDesigner = [[Designer alloc] initWith:dict];
        NSMutableDictionary *planDic = [orderedDesigner.data objectForKey:@"plan"];
        orderedDesigner.plan = [[Plan alloc] initWith:planDic];
        [orderedDesigners addObject:orderedDesigner];
    }
    
    self.orderedDesigners = orderedDesigners;
}

- (void)refreshOrderableDesigners {
    NSMutableDictionary* dataDic = [DataManager shared].data;
    NSArray *arr = [dataDic objectForKey:@"rec_designer"];
    NSMutableArray *recDesigners = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Designer *designer = [[Designer alloc] initWith:dict];
        [recDesigners addObject:designer];
    }
    
    self.recommendedDesigners = recDesigners;
    
    arr = [dataDic objectForKey:@"favorite_designer"];
    NSMutableArray *favoriteDesigners = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Designer *designer = [[Designer alloc] initWith:dict];
        [favoriteDesigners addObject:designer];
    }
    
    self.favoriteDesigners = favoriteDesigners;
}

@end
