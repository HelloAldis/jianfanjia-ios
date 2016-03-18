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

static NSArray *_DesignerAllNotificationsFilter;
static NSArray *_DesignerSystemAnnouncementFilter;
static NSArray *_DesignerRequirmentNotificationFilter;
static NSArray *_DesignerWorksiteNotificationFilter;
static NSArray *_DesignerAllLeaveMsgFilter;

@implementation NotificationBusiness

+ (void)initialize {
    _UserAllNotificationsFilter = @[kUserPNFromSystemMsg, kUserPNFromOrderRespond, kUserPNFromOrderReject, kUserPNFromPlanSubmit, kUserPNFromAgreementConfigure, kUserPNFromMeasureHouseConfirm, kUserPNFromPurchaseTip, kUserPNFromPayTip, kUserPNFromDBYSRequest, kUserPNFromRescheduleRequest, kUserPNFromRescheduleReject, kUserPNFromRescheduleAgree];
    _UserSystemAnnouncementFilter = @[kUserPNFromSystemMsg];
    _UserRequirmentNotificationFilter = @[kUserPNFromOrderRespond, kUserPNFromOrderReject, kUserPNFromPlanSubmit, kUserPNFromAgreementConfigure, kUserPNFromMeasureHouseConfirm];
    _UserWorksiteNotificationFilter = @[kUserPNFromPurchaseTip, kUserPNFromPayTip, kUserPNFromDBYSRequest, kUserPNFromRescheduleRequest, kUserPNFromRescheduleReject, kUserPNFromRescheduleAgree];
    _UserAllLeaveMsgFilter = @[kUserPNFromPlanComment, kUserPNFromDecItemComment];
    
    _DesignerAllNotificationsFilter = @[kDesignerPNFromSystemMsg, kDesignerPNFromBasicInfoAuthPass, kDesignerPNFromBasicInfoAuthNotPass, kDesignerPNFromIDAuthPass, kDesignerPNFromIDAuthNotPass,kDesignerPNFromWorksiteAuthPass, kDesignerPNFromWorksiteAuthNotPass, kDesignerPNFromProductAuthPass, kDesignerPNFromProductAuthNotPass, kDesignerPNFromProductBreakRule, kDesignerPNFromOrderTip, kDesignerPNFromMeasureHouseConfirm, kDesignerPNFromPlanChoose, kDesignerPNFromPlanNotChoose, kDesignerPNFromAgreementConfirm, kDesignerPNFromPurchaseTip, kDesignerPNFromRescheduleRequest, kDesignerPNFromRescheduleReject, kDesignerPNFromRescheduleAgree, kDesignerPNFromDBYSConfirm];
    _DesignerSystemAnnouncementFilter = @[kDesignerPNFromSystemMsg, kDesignerPNFromBasicInfoAuthPass, kDesignerPNFromBasicInfoAuthNotPass, kDesignerPNFromIDAuthPass, kDesignerPNFromIDAuthNotPass,kDesignerPNFromWorksiteAuthPass, kDesignerPNFromWorksiteAuthNotPass, kDesignerPNFromProductAuthPass, kDesignerPNFromProductAuthNotPass, kDesignerPNFromProductBreakRule];
    _DesignerRequirmentNotificationFilter = @[kDesignerPNFromOrderTip, kDesignerPNFromMeasureHouseConfirm, kDesignerPNFromPlanChoose, kDesignerPNFromPlanNotChoose, kDesignerPNFromAgreementConfirm];
    _DesignerWorksiteNotificationFilter = @[kDesignerPNFromPurchaseTip, kDesignerPNFromRescheduleRequest, kDesignerPNFromRescheduleReject, kDesignerPNFromRescheduleAgree, kDesignerPNFromDBYSConfirm];
    _DesignerAllLeaveMsgFilter = @[kDesignerPNFromPlanComment, kDesignerPNFromDecItemComment];
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

+ (NSArray *)designerAllNotificationsFilter {
    return _DesignerAllNotificationsFilter;
}

+ (NSArray *)designerSystemAnnouncementFilter {
    return _DesignerSystemAnnouncementFilter;
}

+ (NSArray *)designerRequirmentNotificationFilter {
    return _DesignerRequirmentNotificationFilter;
}

+ (NSArray *)designerWorksiteNotificationFilter {
    return _DesignerWorksiteNotificationFilter;
}

+ (NSArray *)designerAllLeaveMsgFilter {
    return _DesignerAllLeaveMsgFilter;
}

+ (void)markTextColor:(UILabel *)label status:(NSString *)status {
    [self markTextColor:label status:status read:kNotificationReadColor unread:kThemeTextColor];
}

+ (void)markTextColor:(UILabel *)label status:(NSString *)status unread:(UIColor *)unread {
    [self markTextColor:label status:status read:kNotificationReadColor unread:unread];
}

+ (void)markTextColor:(UILabel *)label status:(NSString *)status read:(UIColor *)read unread:(UIColor *)unread {
    label.textColor = [status isEqualToString:kNotificationStatusReaded] ? read : unread;
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

#pragma mark - util
+ (BOOL)contains:(NSString *)type inFilter:(NSArray *)filter {
    NSUInteger result = [filter indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL flag = [type isEqualToString:obj];
        *stop = flag;
        return flag;
    }];
    
    return result != NSNotFound;
}

@end
