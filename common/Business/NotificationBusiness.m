//
//  NotificationBusiness.m
//  jianfanjia
//
//  Created by Karos on 16/3/10.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "NotificationBusiness.h"

NSString *kNotificationRead = @"1";
NSString *kNotificationUnread = @"0";

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
    label.textColor = [status isEqualToString:kNotificationRead] ? kNotificationReadColor : kThemeTextColor;
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

@end
