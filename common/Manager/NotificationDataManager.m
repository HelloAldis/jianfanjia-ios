//
//  NotificationDataManager.m
//  jianfanjia
//
//  Created by Karos on 15/12/11.
//  Copyright © 2015年 JYZ. All rights reserved.
//
//
//
// Notification Data structure
// {"content":"测试一下离线的","section":"section","type":"type","time":1449800214981,"cell":"cell","processid":"566798dab6c449fd05969fef"}
//
// Purchase notification
// {"content":"水电材料","section":"shui_dian","cell":"复古","type":"1","time":1449881177142,"processid":"566b6dd2e1029ffe2f0b1d24"}
//
// Reschedule notification
// {"content":"设计师唐冕向您提出了改期, 希望可以将验收改期到2015-12-23","type":"0","time":1449900703466,"section":"shui_dian","status":"3","cell":"复古","processid":"566b6dd2e1029ffe2f0b1d24"}
//
// Info notification
// {"content":"设计师已经上传所有验收图片，您可以前往对比验收","type":"3","time":1449902755533,"section":"shui_dian","cell":"复古","processid":"566b6dd2e1029ffe2f0b1d24"}

#import "NotificationDataManager.h"

@interface NotificationDataManager ()

@property (assign, nonatomic) NSInteger myNotificationUnreadCount;
@property (assign, nonatomic) NSInteger myLeaveMsgUnreadCount;

@end

@implementation NotificationDataManager

- (void)receiveNotification:(NSData *)payload andOffLine:(BOOL)offLine {
    if ([GVUserDefaults standardUserDefaults].isLogin) {
        Notification *notification = [self convertPayloadToObj:payload];
        
        if (notification) {
            if (!offLine) {
//                NSString *backupContent = [notification.content copy];
//                if ([notification.type isEqualToString:kNotificationTypePurchase]) {
//                    notification.content = [NSString stringWithFormat:@"系统提醒您进入建材购买阶段，您需要购买的是：%@", notification.content];
//                }
//                [self showLocalNotification:notification];
//                notification.content = backupContent;
            }
        }
    }
}

- (Notification *)convertPayloadToObj:(NSData *)payload {
    NSError *error = nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:payload options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        DDLogError(@"notification error %@", error);
        nil;
    }
    
    Notification *notification = [[Notification alloc] initWith:json];
    notification.userid = [GVUserDefaults standardUserDefaults].userid;
    notification.status = kNotificationStatusUnread;
    
    return notification;
}

- (void)subscribeMyNotificationUnreadCount:(NotificationUnreadUpdateBlock)block {
    [[self rac_valuesAndChangesForKeyPath:@"myNotificationUnreadCount" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTuple *tuple) {
        NSInteger unreadCount = [tuple.first integerValue];
        if (block) {
            block(unreadCount);
        }
    }];
}

- (void)subscribeMyLeaveMsgUnreadCount:(NotificationUnreadUpdateBlock)block {
    [[self rac_valuesAndChangesForKeyPath:@"myLeaveMsgUnreadCount" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTuple *tuple) {
        NSInteger unreadCount = [tuple.first integerValue];
        if (block) {
            block(unreadCount);
        }
    }];
}

- (void)subscribeAppBadgeNumber:(NotificationUnreadUpdateBlock)block {
    [NotificationBusiness setAppBadge:5];
//    [[[UIApplication sharedApplication] rac_valuesAndChangesForKeyPath:@"applicationIconBadgeNumber" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew observer:[UIApplication sharedApplication]] subscribeNext:^(RACTuple *tuple) {
//        NSInteger badgeNumber = [tuple.first integerValue];
//        if (block) {
//            block(badgeNumber);
//        }
//    }];
//    
    
    [RACObserve([UIApplication sharedApplication], applicationIconBadgeNumber) subscribeNext:^(id x) {
        if (block) {
            block([x integerValue]);
        }
    }];
}

- (void)refreshUnreadCount {
    if ([[GVUserDefaults standardUserDefaults].usertype isEqualToString:kUserTypeUser]) {
        GetUserUnreadCount *request = [GetUserUnreadCount requestWithTypes:@[[NotificationBusiness userAllNotificationsFilter], [NotificationBusiness userAllLeaveMsgFilter]]];
        
        [API getUserUnreadCount:request success:^{
            NSArray *arr = [DataManager shared].data;
            self.myNotificationUnreadCount = [arr[0] integerValue];
            self.myLeaveMsgUnreadCount = [arr[1] integerValue];
        } failure:^{
            
        } networkError:^{
            
        }];
    } else if ([[GVUserDefaults standardUserDefaults].usertype isEqualToString:kUserTypeDesigner]) {
        
    }
}

- (void)showLocalNoti:(NSDictionary *)userInfo {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if ([GVUserDefaults standardUserDefaults].isLogin) {
            NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            NSString *payload = [userInfo objectForKey:@"payload1"];
            if (payload) {
                Notification *notification = [self convertPayloadToObj:[payload dataUsingEncoding:NSUTF8StringEncoding]];
                if (notification) {
                    notification.content = [NSString stringWithFormat:@"%@ %@", alert, notification.content];
                    [self showLocalNotification:notification];
                }
            }
        }
    });
}

- (void)showLocalNotification:(Notification *)noti {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate date];
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = 0;
    // 通知内容
    notification.alertBody = noti.content;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:noti.content forKey:[self generateNotificationKey:noti]];
    notification.userInfo = userDict;
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (NSString *)generateNotificationKey:(Notification *)notification {
    return [NSString stringWithFormat:@"%@_%@", notification.userid, notification.type];
}

kSynthesizeSingletonForClass(NotificationDataManager)

@end
