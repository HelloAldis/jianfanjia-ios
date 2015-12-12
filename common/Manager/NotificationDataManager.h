//
//  NotificationDataManager.h
//  jianfanjia
//
//  Created by Karos on 15/12/11.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NotificationCD;

typedef void (^NotificationUnreadUpdateBlock)(id value);

@interface NotificationDataManager : NSObject

@property (assign, nonatomic) NSInteger payUnreadCount;
@property (assign, nonatomic) NSInteger purchaseUnreadCount;
@property (assign, nonatomic) NSInteger rescheduleUnreadCount;
@property (assign, nonatomic) NSInteger totalUnreadCount;

- (void)receiveNotification:(NSData *)payload;
- (void)refreshUnreadCount;
- (void)subscribePurchaseUnreadCount:(NotificationUnreadUpdateBlock)block;
- (void)subscribePayUnreadCount:(NotificationUnreadUpdateBlock)block;
- (void)subscribeRescheduleUnreadCount:(NotificationUnreadUpdateBlock)block;
- (void)subscribeAllUnreadCount:(NotificationUnreadUpdateBlock)block;

- (void)subscribeUnreadCountForProcess:(NSString *)processid observer:(NotificationUnreadUpdateBlock)block;
- (void)subscribeUnreadCountForProcess:(NSString *)processid type:(NSString *)type observer:(NotificationUnreadUpdateBlock)block;

- (void)markNotificationToRead:(NotificationCD *)notification;

kSynthesizeSingletonForHeader(NotificationDataManager)

@end
