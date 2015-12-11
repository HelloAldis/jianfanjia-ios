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
- (void)observePurchaseUnreadCount:(NotificationUnreadUpdateBlock)block;
- (void)observePayUnreadCount:(NotificationUnreadUpdateBlock)block;
- (void)observeRescheduleUnreadCount:(NotificationUnreadUpdateBlock)block;
- (void)observeAllUnreadCount:(NotificationUnreadUpdateBlock)block;

- (void)observePurchaseUnreadCount:(NotificationUnreadUpdateBlock)block process:(NSString *)processid;
- (void)observePayUnreadCount:(NotificationUnreadUpdateBlock)block process:(NSString *)processid;
- (void)observeRescheduleUnreadCount:(NotificationUnreadUpdateBlock)block process:(NSString *)processid;

- (void)observePurchaseUnreadCount:(NotificationUnreadUpdateBlock)block process:(NSString *)processid type:(NSString *)type;
- (void)observePayUnreadCount:(NotificationUnreadUpdateBlock)block process:(NSString *)processid type:(NSString *)type;
- (void)observeRescheduleUnreadCount:(NotificationUnreadUpdateBlock)block process:(NSString *)processid type:(NSString *)type;

- (void)markNotificationToRead:(NotificationCD *)notification;

kSynthesizeSingletonForHeader(NotificationDataManager)

@end
