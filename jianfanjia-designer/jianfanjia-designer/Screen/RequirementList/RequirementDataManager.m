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
        User *user = [[User alloc] initWith:[comment.data objectForKey:@"byUser"]];
        Designer *designer = [[Designer alloc] initWith:[comment.data objectForKey:@"byDesigner"]];
        Supervisor *supervisor = [[Supervisor alloc] initWith:[comment.data objectForKey:@"bySupervisor"]];
        comment.user = user;
        comment.designer = designer;
        comment.supervisor = supervisor;
        [comments addObject:comment];
    }
    
    self.comments = comments;
}

- (void)loadMoreComments {
    NSArray* arr = [[DataManager shared].data objectForKey:@"comments"];
    NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Comment *comment = [[Comment alloc] initWith:dict];
        User *user = [[User alloc] initWith:[comment.data objectForKey:@"byUser"]];
        Designer *designer = [[Designer alloc] initWith:[comment.data objectForKey:@"byDesigner"]];
        Supervisor *supervisor = [[Supervisor alloc] initWith:[comment.data objectForKey:@"bySupervisor"]];
        comment.user = user;
        comment.designer = designer;
        comment.supervisor = supervisor;
        [comments addObject:comment];
    }
    
    [self.comments addObjectsFromArray:comments];
}

@end
