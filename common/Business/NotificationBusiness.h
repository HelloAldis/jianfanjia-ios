//
//  NotificationBusiness.h
//  jianfanjia
//
//  Created by Karos on 16/3/10.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NotificationReadBlock)(void);

extern NSString * const kNotificationStatusUnread;
extern NSString * const kNotificationStatusReaded;

@interface NotificationBusiness : NSObject

+ (NSArray *)userAllNotificationsFilter;
+ (NSArray *)userSystemAnnouncementFilter;
+ (NSArray *)userRequirmentNotificationFilter;
+ (NSArray *)userWorksiteNotificationFilter;
+ (NSArray *)userAllLeaveMsgFilter;

+ (NSArray *)designerAllNotificationsFilter;
+ (NSArray *)designerSystemAnnouncementFilter;
+ (NSArray *)designerRequirmentNotificationFilter;
+ (NSArray *)designerWorksiteNotificationFilter;
+ (NSArray *)designerAllLeaveMsgFilter;

+ (void)markTextColor:(UILabel *)label status:(NSString *)status;
+ (NSInteger)appBadge;
+ (void)setAppBadge:(NSInteger)appBdge;
+ (void)reduceOneBadge;
+ (void)addOneBadge;

+ (BOOL)contains:(NSString *)type inFilter:(NSArray *)filter;

@end
