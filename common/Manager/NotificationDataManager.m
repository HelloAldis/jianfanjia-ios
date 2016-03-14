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
/**
 badge = 1;
 content = "\U5c0a\U656c\U7684\U4e1a\U4e3b\U60a8\U597d\Uff1a\U60a8\U7684\U8bbe\U8ba1\U5e08\U5468\U5fd7\U6587\U5e0c\U671b\U5c06\U672c\U9636\U6bb5\U5de5\U671f\U4fee\U6539\U81f32017-03-06\Uff0c\U7b49\U5f85\U60a8\U7684\U786e\U8ba4\Uff01\U5982\U6709\U95ee\U9898\U8bf7\U53ca\U65f6\U4e0e\U8bbe\U8ba1\U5e08\U8054\U7cfb\Uff0c\U4e5f\U53ef\U4ee5\U62e8\U6253\U6211\U4eec\U7684\U5ba2\U670d\U70ed\U7ebf\Uff1a400-8515-167";
 messageid = 56e6707de9cbb7a128f3016a;
 status = 0;
 time = 1457942653384;
 type = 0;
 userid = 568494454ade4cb02eeff7c5;
 */

#import "NotificationDataManager.h"

@interface NotificationDataManager ()

@property (assign, nonatomic) NSInteger myNotificationUnreadCount;
@property (assign, nonatomic) NSInteger myLeaveMsgUnreadCount;
@property (assign, nonatomic) NSInteger myTotalUnreadCount;

@end

@implementation NotificationDataManager

- (id)init {
    [RACObserve([UIApplication sharedApplication], applicationIconBadgeNumber) subscribeNext:^(id x) {
        [self refreshUnreadCount];
    }];
    return [super init];
}

- (void)receiveNotification:(NSData *)payload andOffLine:(BOOL)offLine {
    if ([GVUserDefaults standardUserDefaults].isLogin) {
        if (offLine) {
            [self refreshUnreadCount];
        }
        
        Notification *notification = [self convertPayloadToObj:payload];
        
        if (notification) {
            
            
//            [NotificationBusiness setAppBadge:notification.badge.integerValue];
            
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
    [[self rac_valuesAndChangesForKeyPath:@"myTotalUnreadCount" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTuple *tuple) {
        NSInteger unreadCount = [tuple.first integerValue];
        if (block) {
            block(unreadCount);
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
            self.myTotalUnreadCount = self.myNotificationUnreadCount + self.myLeaveMsgUnreadCount;
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
