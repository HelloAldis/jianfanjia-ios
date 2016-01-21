//
//  MyUserDataManager.m
//  jianfanjia-designer
//
//  Created by Karos on 16/1/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

/**
 预约方案状态 plan status
 * 0. 已预约但没有响应
 * 1. 已拒绝业主
 * 2. 已响应但是没有确认量房
 * 3. 提交了方案
 * 4. 方案被未中标
 * 5. 方案被选中
 * 6. 已确认量房但是没有方案
 * 7. 设计师无响应导致响应过期 (目前去掉了)
 * 8. 设计师规定时间内没有上场方案，过期
 */

#import "MyUserDataManager.h"

static NSArray *unprocessStatusArr = nil;
static NSArray *processingStatusArr = nil;
static NSArray *processedStatusArr = nil;

@implementation MyUserDataManager

+ (void)initialize {
    if (self == [MyUserDataManager self]) {
        unprocessStatusArr = @[@"0"];
        processingStatusArr = @[@"2", @"3", @"5", @"6"];
        processedStatusArr = @[@"1", @"4", @"8"];
    }
}

- (void)refreshAllActions {
    NSArray* arr = [DataManager shared].data;
    NSMutableArray *unprocessActions = [NSMutableArray array];
    NSMutableArray *processingActions = [NSMutableArray array];
    NSMutableArray *processedActions = [NSMutableArray array];
    
    for (NSMutableDictionary *dict in arr) {
        Requirement *requirement = [[Requirement alloc] initWith:dict];
        User *user = [[User alloc] initWith:[requirement.data objectForKey:@"user"]];
        Plan *plan = [[Plan alloc] initWith:[requirement.data objectForKey:@"plan"]];
        Evaluation *evaluation = [[Evaluation alloc] initWith:[requirement.data objectForKey:@"evaluation"]];
        requirement.user = user;
        requirement.plan = plan;
        requirement.evaluation = evaluation;
        
        if ([unprocessStatusArr containsObject:requirement.plan.status]) {
            [unprocessActions addObject:requirement];
        } else if ([processingStatusArr containsObject:requirement.plan.status]) {
            [processingActions addObject:requirement];
        } else if ([processedStatusArr containsObject:requirement.plan.status]) {
            [processedActions addObject:requirement];
        }
    }
    
    self.unprocessActions = [self descendActions:unprocessActions];
    self.processingActions = [self descendActions:processingActions];
    self.processedActions = [self descendActions:processedActions];
}

- (NSArray *)descendActions:(NSArray *)actions {
    return [actions sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(Requirement*  _Nonnull obj1, Requirement*  _Nonnull obj2) {
        if ([obj1.plan.last_status_update_time compare:obj2.plan.last_status_update_time] == NSOrderedAscending) {
            return NSOrderedDescending;
        } else if ([obj1.plan.last_status_update_time compare:obj2.plan.last_status_update_time] == NSOrderedDescending) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
}

@end
