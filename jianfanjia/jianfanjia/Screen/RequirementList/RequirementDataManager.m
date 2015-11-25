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
        Requirement *requirement = [[Requirement alloc] initWith:dict];
        Process *process = [[Process alloc] initWith:[requirement.data objectForKey:@"process"]];
        requirement.process = process;
        
        [requirements addObject:requirement];
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

- (void)refreshOrderedDesigners {
    NSArray* arr = [DataManager shared].data;
    NSMutableArray *orderedDesigners = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Designer *orderedDesigner = [[Designer alloc] initWith:dict];
        NSMutableDictionary *planDic = [orderedDesigner.data objectForKey:@"plan"];
        NSMutableDictionary *requirementDic = [orderedDesigner.data objectForKey:@"requirement"];
        NSMutableDictionary *evaluationDic = [orderedDesigner.data objectForKey:@"evaluation"];
        
        orderedDesigner.plan = [[Plan alloc] initWith:planDic];
        orderedDesigner.requirement = [[Requirement alloc] initWith:requirementDic];
        orderedDesigner.evaluation = [[Evaluation alloc] initWith:evaluationDic];
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
