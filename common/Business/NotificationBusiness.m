//
//  NotificationBusiness.m
//  jianfanjia
//
//  Created by Karos on 16/3/10.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "NotificationBusiness.h"

/*
 推送消息类型 message_status
 * 0. 未读
 * 1. 已读
 **/
NSString * const kNotificationStatusUnread = @"0";
NSString * const kNotificationStatusReaded = @"1";

static NSArray *_UserAllNotificationsFilter;
static NSArray *_UserSystemAnnouncementFilter;
static NSArray *_UserRequirmentNotificationFilter;
static NSArray *_UserWorksiteNotificationFilter;
static NSArray *_UserAllLeaveMsgFilter;

@implementation NotificationBusiness

+ (void)initialize {
    _UserAllNotificationsFilter = @[kUserPNFromSystemMsg, kUserPNFromOrderRespond, kUserPNFromOrderReject, kUserPNFromPlanSubmit, kUserPNFromAgreementConfigure, kUserPNFromPurchaseTip, kUserPNFromPayTip, kUserPNFromDBYSRequest, kUserPNFromRescheduleRequest, kUserPNFromRescheduleReject, kUserPNFromRescheduleAgree];
    _UserSystemAnnouncementFilter = @[kUserPNFromSystemMsg];
    _UserRequirmentNotificationFilter = @[kUserPNFromOrderRespond, kUserPNFromOrderReject, kUserPNFromPlanSubmit, kUserPNFromAgreementConfigure];
    _UserWorksiteNotificationFilter = @[kUserPNFromPurchaseTip, kUserPNFromPayTip, kUserPNFromDBYSRequest, kUserPNFromRescheduleRequest, kUserPNFromRescheduleReject, kUserPNFromRescheduleAgree];
    _UserAllLeaveMsgFilter = @[kUserPNFromPlanComment, kUserPNFromDecItemComment];
}

+ (NSArray *)userAllNotificationsFilter {
    return _UserAllNotificationsFilter;
}

+ (NSArray *)userSystemAnnouncementFilter {
    return _UserSystemAnnouncementFilter;
}

+ (NSArray *)userRequirmentNotificationFilter {
    return _UserRequirmentNotificationFilter;
}

+ (NSArray *)userWorksiteNotificationFilter {
    return _UserWorksiteNotificationFilter;
}

+ (NSArray *)userAllLeaveMsgFilter {
    return _UserAllLeaveMsgFilter;
}

+ (void)markTextColor:(UILabel *)label status:(NSString *)status {
    label.textColor = [status isEqualToString:kNotificationStatusReaded] ? kNotificationReadColor : kThemeTextColor;
}

+ (NSInteger)appBadge {
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

+ (void)setAppBadge:(NSInteger)appBdge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = appBdge;
}

+ (void)reduceOneBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
}

+ (void)addOneBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
}

@end
