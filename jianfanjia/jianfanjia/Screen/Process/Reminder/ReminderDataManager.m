//
//  ReminderDataManager.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ReminderDataManager.h"

@implementation ReminderDataManager

- (void)refreshSchedule {
    NSArray *arr = [DataManager shared].data;
    NSMutableArray *schedules = [arr map:^id(id obj) {
        Schedule *schedule = [[Schedule alloc] initWith:obj];
        schedule.process = [[Process alloc] initWith:[schedule.data objectForKey:@"process"]];
        
        return schedule;
    }];
    
    self.schedules = schedules;
}

@end
