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

static NSString *PROCESS = @"processid";
static NSString *SET_PROCESS = @"setProcessid";

static NSString *PROCESS_TYPE = @"processid_type";
static NSString *SET_PROCESS_TYPE = @"setProcessid_type";

@interface NotificationDataManager ()

@property (strong, nonatomic) NSMutableDictionary *data;

@end

@implementation NotificationDataManager

- (void)receiveNotification:(NSData *)payload andOffLine:(BOOL)offLine {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if ([GVUserDefaults standardUserDefaults].isLogin) {
            Notification *notification = [self convertPayloadToObj:payload];
            
            if (notification) {
                if (!offLine) {
                    [self showLocalNotification:notification];
                }
                
                if ([notification.type isEqualToString:kNotificationTypeDBYS]) {
                    [self broadcastNotification:notification];
                } else {
                    [self insertNotification:notification];
                    [self refreshUnreadCount];
                }
            }
        }
    });
}

- (void)refreshUnreadCount {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if ([GVUserDefaults standardUserDefaults].isLogin) {
            self.purchaseUnreadCount = [NotificationCD getNotificationsCountWithType:kNotificationTypePurchase status:kNotificationStatusUnread];
            self.payUnreadCount = [NotificationCD getNotificationsCountWithType:kNotificationTypePay status:kNotificationStatusUnread];
            self.rescheduleUnreadCount = [NotificationCD getNotificationsCountWithType:kNotificationTypeReschedule status:kNotificationStatusUnread];
            self.totalUnreadCount = self.purchaseUnreadCount + self.payUnreadCount + self.rescheduleUnreadCount;
            
            NSArray *allProcessNotifications = [NotificationCD getNotifications];
            for (id notification in allProcessNotifications) {
                NSString *processid = [notification processid];
                NSUInteger process_purchase_unread_count = [NotificationCD getNotificationsCountWithProcess:processid type:kNotificationTypePurchase status:kNotificationStatusUnread];
                NSUInteger process_pay_unread_count = [NotificationCD getNotificationsCountWithProcess:processid type:kNotificationTypePay status:kNotificationStatusUnread];
                NSUInteger process_reschedule_unread_count = [NotificationCD getNotificationsCountWithProcess:processid type:kNotificationTypeReschedule status:kNotificationStatusUnread];
                NSUInteger total_type_unread_count = process_purchase_unread_count + process_pay_unread_count + process_reschedule_unread_count;
                [self setValue:@(process_purchase_unread_count) forProperty:[self setSelStrWithProcess:processid type:kNotificationTypePurchase]];
                [self setValue:@(process_pay_unread_count) forProperty:[self setSelStrWithProcess:processid type:kNotificationTypePay]];
                [self setValue:@(process_reschedule_unread_count) forProperty:[self setSelStrWithProcess:processid type:kNotificationTypeReschedule]];
                [self setValue:@(total_type_unread_count) forProperty:[self setSelStrWithProcess:processid]];
            }
        }
    });
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

- (void)insertNotification:(Notification *)notification {
    [NotificationCD insert:notification];
}

- (void)markToReadForType:(NSString *)type {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *notifications = [NotificationCD getNotificationsWithType:type status:kNotificationStatusUnread];
        for (NotificationCD *notification in notifications) {
            notification.status = kNotificationStatusReaded;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (notifications.count > 0) {
                [NSManagedObjectContext save];
                [self refreshUnreadCount];
            }
        });
    });
}

- (void)markToReadForProcess:(NSString *)processid type:(NSString *)type {
    NSArray *notifications = [NotificationCD getNotificationsWithProcess:processid type:type status:kNotificationStatusUnread];
    for (NotificationCD *notification in notifications) {
        notification.status = kNotificationStatusReaded;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (notifications.count > 0) {
            [NSManagedObjectContext save];
            [self refreshUnreadCount];
        }
    });
}

- (void)subscribePurchaseUnreadCount:(NotificationUnreadUpdateBlock)block {
    [[RACObserve(self, purchaseUnreadCount)
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(id x) {
            if (block) {
                block(x);
            }
        }];
}

- (void)subscribePayUnreadCount:(NotificationUnreadUpdateBlock)block {
    [[RACObserve(self, payUnreadCount)
         deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
            if (block) {
                block(x);
            }
         }];
}

- (void)subscribeRescheduleUnreadCount:(NotificationUnreadUpdateBlock)block {
    [[RACObserve(self, rescheduleUnreadCount)
         deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
            if (block) {
                block(x);
            }
         }];
}

- (void)subscribeAllUnreadCount:(NotificationUnreadUpdateBlock)block {
    [[RACObserve(self, totalUnreadCount)
         deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = [x integerValue];
            if (block) {
                block(x);
            }
        }];
}

- (void)subscribeUnreadCountForProcess:(NSString *)processid observer:(NotificationUnreadUpdateBlock)block  {
    [[[self.data rac_valuesForKeyPath:[self selStrWithProcess:processid] observer:self.data]
         deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
            if (block) {
                block(x);
            }
        }];
}

- (void)subscribeUnreadCountForProcess:(NSString *)processid type:(NSString *)type observer:(NotificationUnreadUpdateBlock)block  {
    [[[self.data rac_valuesForKeyPath:[self selStrWithProcess:processid type:type] observer:self.data]
         deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
            if (block) {
                block(x);
            }
        }];
}

- (void)realtimeUnreadCountForProcess:(NSString *)processid observer:(NotificationUnreadUpdateBlock)block  {
    [[[self.data rac_valuesForKeyPath:[self selStrWithProcess:processid] observer:self.data]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         if (block) {
             block(x);
         }
     }];
}

- (void)showLocalNoti:(NSDictionary *)userInfo {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if ([GVUserDefaults standardUserDefaults].isLogin) {
            NSString *payload = [userInfo objectForKey:@"payload1"];
            Notification *notification = [self convertPayloadToObj:[payload dataUsingEncoding:NSUTF8StringEncoding]];
            if (notification) {
                [self showLocalNotification:notification];
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

- (void)broadcastNotification:(Notification *)noti {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDBYS object:noti];
}

#pragma mark - Getters and Setters for dynamic properties
- (void)setValue:(id)value forProperty:(NSString *)selector {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(selector) withObject:value];
#pragma clang diagnostic pop
}

- (id)getValueFromProperty:(NSString *)selector {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:NSSelectorFromString(selector)];
#pragma clang diagnostic pop
}

- (NSString *)selStrWithProcess:(NSString *)processid {
    return [NSString stringWithFormat:@"%@_%@", PROCESS, processid];
}

- (NSString *)setSelStrWithProcess:(NSString *)processid {
    return [NSString stringWithFormat:@"%@_%@:", SET_PROCESS, processid];
}

- (NSString *)selStrWithProcess:(NSString *)processid type:(NSString *)type {
    return [NSString stringWithFormat:@"%@_%@_%@", PROCESS_TYPE, processid, type];
}

- (NSString *)setSelStrWithProcess:(NSString *)processid type:(NSString *)type {
    return [NSString stringWithFormat:@"%@_%@_%@:", SET_PROCESS_TYPE, processid, type];
}

- (instancetype)init {
    if (self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setObject:(id)o forKey:(NSString *)key {
    [[self data] setObject:o forKey:key];
}

- (id)objectForKey:(NSString *)key {
    return [[self data] objectForKey:key];
}

/**
 Description: Save the properties in a dictionary.
 @param self Target
 @param _cmd A selector
 @param value The new values that will be saved in a dictionary
 */
void notificationSetterImp(id self, SEL _cmd, id value) {
    @try {
        NSString *selStr = NSStringFromSelector(_cmd);
        if ([[selStr substringToIndex:3] isEqualToString:@"set"])
            selStr = [selStr substringFromIndex:3];
        selStr = [[selStr substringWithoutLast:1] lowercaseFirstLetterString];
        NSString *key = selStr;
        [self setObject:value forKey:key];
    }
    @catch (NSException *exception) {}
}

/**
 Description: Get the properties value by specified key.
 @param self Target
 @param _cmd A selector
 */
NSObject* notificationGetterImp(id self, SEL _cmd) {
    @try {
        NSString *key = NSStringFromSelector(_cmd);
        id obj = [self objectForKey:key];
        return obj;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

#pragma mark - Dynamic adding properties
/**
 Description: An instance method to add setter or getter method for a class.
 @param aSEL A selector
 */
+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
    NSString *selStr = NSStringFromSelector(aSEL);
    
    if ([[selStr lowercaseString] containsString:PROCESS]
        || [[selStr lowercaseString] containsString:PROCESS_TYPE]) {
        if ([[selStr substringToIndex:3] isEqualToString:@"set"]) {
            class_addMethod([self class], aSEL, (IMP) notificationSetterImp, "v@:@");
            return YES;
        } else {
            class_addMethod([self class], aSEL, (IMP) notificationGetterImp, "@@:");
            return YES;
        }
    }
    
    return [super resolveInstanceMethod:aSEL];
}

kSynthesizeSingletonForClass(NotificationDataManager)

@end
