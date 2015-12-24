//
//  Bc.h
//  jianfanjia
//
//  Created by JYZ on 15/10/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kKeychainService;
extern int const kWelconeVersion;
extern int const kPhoneLength;
extern int const kPasswordLength;
extern NSString * const kUserTypeUser;
extern NSString * const kUserTypeDesigner;
extern NSString * const kProcessItemStatusNew;
extern NSString * const kProcessItemStatusGoing;
extern NSString * const kProcessItemStatusDone;
extern NSString * const kProcessItemStatusRescheduleReqNew;
extern NSString * const kProcessItemStatusRescheduleOk;
extern NSString * const kProcessItemStatusRescheduleReject;

extern NSUInteger const kMaxOrderableDesignerCount;
extern NSString * const kPlanStatusUnorder;
extern NSString * const kPlanStatusHomeOwnerOrderedWithoutResponse;
extern NSString * const kPlanStatusDesignerDeclineHomeOwner;
extern NSString * const kPlanStatusDesignerRespondedWithoutMeasureHouse;
extern NSString * const kPlanStatusDesignerSubmittedPlan;
extern NSString * const kPlanStatusPlanWasNotChoosed;
extern NSString * const kPlanStatusPlanWasChoosed;
extern NSString * const kPlanStatusDesignerMeasureHouseWithoutPlan;
extern NSString * const kPlanStatusExpiredAsDesignerDidNotRespond;
extern NSString * const kPlanStatusExpiredAsDesignerDidProvidePlanInSpecifiedTime;

extern NSString * const kRequirementStatusUnorderAnyDesigner;
extern NSString * const kRequirementStatusOrderedDesignerWithoutAnyResponse;
extern NSString * const kRequirementStatusDesignerRespondedWithoutMeasureHouse;
extern NSString * const kRequirementStatusDesignerSubmittedPlanWithoutResponse;
extern NSString * const kRequirementStatusPlanWasChoosedWithoutAgreement;
extern NSString * const kRequirementStatusConfiguredWorkSite;
extern NSString * const kRequirementStatusDesignerMeasureHouseWithoutPlan;
extern NSString * const kRequirementStatusConfiguredAgreementWithoutWorkSite;

extern NSString * const kAuthTypeUnverify;
extern NSString * const kAuthTypeVerifyPass;
extern NSString * const kAuthTypeVerifyNotPass;
extern NSString * const kAuthTypeBreakRule;

extern NSString * const kTopicTypePlan;
extern NSString * const kTopicTypeProcess;

extern NSString * const kSectionStatusUnStart;
extern NSString * const kSectionStatusOnGoing;
extern NSString * const kSectionStatusAlreadyFinished;
extern NSString * const kSectionStatusChangeDateRequest;
extern NSString * const kSectionStatusChangeDateAgree;
extern NSString * const kSectionStatusChangeDateDecline;

extern NSString * const kNotificationStatusUnread;
extern NSString * const kNotificationStatusReaded;

extern NSString * const kNotificationTypePurchase;
extern NSString * const kNotificationTypePay;
extern NSString * const kNotificationTypeReschedule;
extern NSString * const kNotificationTypeDBYS;
extern NSString * const kDecTypeHouse;
extern NSString * const kDecTypeBusiness;