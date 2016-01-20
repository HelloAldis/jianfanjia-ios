//
//  ReminderDataManager.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReminderDataManager : NSObject

@property (strong, nonatomic) NSMutableArray *schedules;
@property (strong, nonatomic) NSArray *notifications;

- (void)refreshSchedule:(NSString *)processid;
- (void)refreshNotificationWithProcess:(NSString *)processid type:(NSString *)type;
- (void)refreshNotificationWithProcess:(NSString *)processid type:(NSString *)type status:(NSString *)status;

@end
