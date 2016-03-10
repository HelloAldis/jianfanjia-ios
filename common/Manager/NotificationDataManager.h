//
//  NotificationDataManager.h
//  jianfanjia
//
//  Created by Karos on 15/12/11.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NotificationUnreadUpdateBlock)(NSInteger count);

@interface NotificationDataManager : NSObject

- (void)subscribeMyNotificationUnreadCount:(NotificationUnreadUpdateBlock)block;
- (void)subscribeMyLeaveMsgUnreadCount:(NotificationUnreadUpdateBlock)block;
- (void)subscribeAppBadgeNumber:(NotificationUnreadUpdateBlock)block;
- (void)refreshUnreadCount;

- (void)receiveNotification:(NSData *)payload andOffLine:(BOOL)offLine;
- (void)showLocalNoti:(NSDictionary *)userInfo;

kSynthesizeSingletonForHeader(NotificationDataManager)

@end
