//
//  NotificationBusiness.h
//  jianfanjia
//
//  Created by Karos on 16/3/10.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kNotificationRead;
extern NSString *kNotificationUnread;

@interface NotificationBusiness : NSObject

+ (NSArray *)userAllNotificationsFilter;
+ (NSArray *)userSystemAnnouncementFilter;
+ (NSArray *)userRequirmentNotificationFilter;
+ (NSArray *)userWorksiteNotificationFilter;
+ (NSArray *)userAllLeaveMsgFilter;

+ (void)markTextColor:(UILabel *)label status:(NSString *)status;
+ (NSInteger)appBadge;
+ (void)setAppBadge:(NSInteger)appBdge;
+ (void)reduceOneBadge;

@end
