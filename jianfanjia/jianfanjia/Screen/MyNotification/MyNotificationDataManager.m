//
//  ReminderDataManager.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MyNotificationDataManager.h"

@implementation MyNotificationDataManager

//- (void)refreshSchedule:(NSString *)processid {
//    NSArray *arr = [DataManager shared].data;
//    NSMutableArray *schedules = [NSMutableArray array];
//    
//    for (NSMutableDictionary *obj in arr) {
//        Schedule *schedule = [[Schedule alloc] initWith:obj];
//        schedule.process = [[Process alloc] initWith:[schedule.data objectForKey:@"process"]];
//        
//        if (processid) {
//            if ([processid isEqualToString:schedule.process._id]) {
//                [schedules addObject:schedule];
//            }
//        } else {
//            [schedules addObject:schedule];
//        }
//    }
//    
//    self.schedules = schedules;
//}
//
//- (void)refreshNotificationWithProcess:(NSString *)processid type:(NSString *)type status:(NSString *)status {
//    self.notifications = [NotificationCD getNotificationsWithProcess:processid type:type status:status];
//}
//
//- (void)refreshNotificationWithProcess:(NSString *)processid type:(NSString *)type {
//    self.notifications = [NotificationCD getNotificationsWithProcess:processid type:type];
//}

+ (void)initialize {
    if ([self class] == [MyNotificationDataManager class]) {
        SystemAnnouncementFilter = @[kUserPNFromSystemMsg];
        RequirmentNotificationFilter = @[kUserPNFromPlanComment, kUserPNFromOrderRespond, kUserPNFromOrderReject, kUserPNFromPlanSubmit, kUserPNFromAgreementConfigure];
        WorksiteNotificationFilter = @[kUserPNFromPurchaseTip, kUserPNFromPayTip, kUserPNFromDBYSRequest, kUserPNFromRescheduleRequest, kUserPNFromRescheduleReject, kUserPNFromRescheduleAgree];
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
        Designer *designer = [[Designer alloc] initWith:[requirement.data objectForKey:@"designer"]];
        Evaluation *evaluation = [[Evaluation alloc] initWith:[requirement.data objectForKey:@"evaluation"]];
        requirement.user = user;
        requirement.plan = plan;
        requirement.designer = designer;
        requirement.evaluation = evaluation;
        
//        if ([unprocessStatusArr containsObject:requirement.plan.status]) {
//            [unprocessActions addObject:requirement];
//        } else if ([processingStatusArr containsObject:requirement.plan.status]) {
//            if (![requirement.status isEqualToString:kRequirementStatusConfiguredWorkSite]
//                && ![requirement.status isEqualToString:kRequirementStatusFinishedWorkSite]) {
//                [processingActions addObject:requirement];
//            }
//        } else if ([processedStatusArr containsObject:requirement.plan.status]) {
//            [processedActions addObject:requirement];
//        }
    }
}

@end
