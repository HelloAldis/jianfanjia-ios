//
//  Bc.h
//  jianfanjia
//
//  Created by JYZ on 15/10/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UnorderColor [UIColor colorWithR:0xb5 g:0xb9 b:0xbc]
#define OrderedColor [UIColor colorWithR:0x11 g:0xbe b:0x62]
#define PlanChoosedColor [UIColor colorWithR:0xfe g:0x70 b:0x04]

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



