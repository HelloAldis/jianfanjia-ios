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

- (void)showLocalNotification:(NSDictionary *)userInfo;
- (void)triggerToShowDetail:(NSDictionary *)userinfo;

kSynthesizeSingletonForHeader(NotificationDataManager)

@end
