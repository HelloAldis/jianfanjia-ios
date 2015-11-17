//
//  RequirementListData.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementDataManager.h"

@implementation RequirementDataManager

- (void)refresh {
    NSArray* arr = [DataManager shared].data;
    NSMutableArray *requirements = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        [requirements addObject:[[Requirement alloc] initWith:dict]];
    }
    
    self.requirements = requirements;
    
}

@end
