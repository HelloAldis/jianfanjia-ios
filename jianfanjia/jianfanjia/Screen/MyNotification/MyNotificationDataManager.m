//
//  ReminderDataManager.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MyNotificationDataManager.h"

@implementation MyNotificationDataManager

- (void)refreshSchedule:(NSString *)processid {
    NSArray *arr = [DataManager shared].data;
    NSMutableArray *schedules = [NSMutableArray array];
    
    for (NSMutableDictionary *obj in arr) {
        Schedule *schedule = [[Schedule alloc] initWith:obj];
        schedule.process = [[Process alloc] initWith:[schedule.data objectForKey:@"process"]];
        
        if (processid) {
            if ([processid isEqualToString:schedule.process._id]) {
                [schedules addObject:schedule];
            }
        } else {
            [schedules addObject:schedule];
        }
    }
    
    self.schedules = schedules;
}

- (void)refreshNotificationWithProcess:(NSString *)processid type:(NSString *)type status:(NSString *)status {
    self.notifications = [NotificationCD getNotificationsWithProcess:processid type:type status:status];
}

- (void)refreshNotificationWithProcess:(NSString *)processid type:(NSString *)type {
    self.notifications = [NotificationCD getNotificationsWithProcess:processid type:type];
}

@end
