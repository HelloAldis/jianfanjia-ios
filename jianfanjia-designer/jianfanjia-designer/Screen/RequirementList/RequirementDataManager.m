//
//  RequirementListData.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementDataManager.h"

@implementation RequirementDataManager

- (void)refreshRequirementPlans {
    NSArray* arr = [DataManager shared].data;
    NSMutableArray *requirementPlans = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Plan *plan = [[Plan alloc] initWith:dict];
        [requirementPlans addObject:plan];
    }
    
    self.requirementPlans = requirementPlans;
}

- (void)refreshPlanPriceItems:(Plan *)plan {
    NSArray* arr = [plan.data objectForKey:@"price_detail"];
    NSMutableArray *planPriceItems = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        PriceItem *plan = [[PriceItem alloc] initWith:dict];
        [planPriceItems addObject:plan];
    }
    
    self.planPriceItems = planPriceItems;
}

- (void)refreshComments {
    NSArray* arr = [[DataManager shared].data objectForKey:@"comments"];
    NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Comment *comment = [[Comment alloc] initWith:dict];
        NSMutableDictionary *userDic = [comment.data objectForKey:@"byUser"];
        User *user = [[User alloc] initWith:userDic];
        comment.user = user;
        [comments addObject:comment];
    }
    
    self.comments = comments;
}

- (void)loadMoreComments {
    NSArray* arr = [[DataManager shared].data objectForKey:@"comments"];
    NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Comment *comment = [[Comment alloc] initWith:dict];
        NSMutableDictionary *userDic = [comment.data objectForKey:@"byUser"];
        User *user = [[User alloc] initWith:userDic];
        comment.user = user;
        [comments addObject:comment];
    }
    
    [self.comments addObjectsFromArray:comments];
}

@end
