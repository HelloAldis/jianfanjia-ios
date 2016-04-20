//
//  NotificationDataManager.h
//  jianfanjia
//
//  Created by Karos on 15/12/11.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString const * kLocalNotificationKey;
extern NSString *kShowNotificationDetail;

typedef void (^NotificationUnreadUpdateBlock)(NSInteger count);

@interface NotificationDataManager : NSObject

- (void)subscribeMyNotificationUnreadCount:(NotificationUnreadUpdateBlock)block;
- (void)subscribeMyLeaveMsgUnreadCount:(NotificationUnreadUpdateBlock)block;
- (void)subscribeAppBadgeNumber:(NotificationUnreadUpdateBlock)block;
- (void)refreshUnreadCount;
- (void)clearUnreadCount;

- (void)receiveNotification:(NSData *)payload andOffLine:(BOOL)offLine;
- (void)remoteTriggerToShowDetail:(NSDictionary *)userInfo;
- (void)localTriggerToShowDetail:(NSDictionary *)userInfo;

kSynthesizeSingletonForHeader(NotificationDataManager)

@end
