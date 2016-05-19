//
//  DesignerListDataManager.m
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "TeamAuthDataManager.h"

@implementation TeamAuthDataManager

- (NSInteger)refresh {
    NSArray* arr = [DataManager shared].data;
    NSMutableArray *teams = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Team *team = [[Team alloc] initWith:dict];
        [teams addObject:team];
    }
    
    self.teams = teams;
    return teams.count;
}

- (NSInteger)loadMore {
    NSArray* arr = [DataManager shared].data;
    NSMutableArray *teams = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Team *team = [[Team alloc] initWith:dict];
        [teams addObject:team];
    }
    
    [self.teams addObjectsFromArray:teams];
    return teams.count;
}

@end
