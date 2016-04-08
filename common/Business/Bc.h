//
//  Bc.h
//  jianfanjia
//
//  Created by JYZ on 15/10/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kKeychainService;
extern NSString * const kPkg365Url;
extern int const kWelcomeVersion;
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
extern NSString * const kPlanStatusExpiredAsDesignerDidNotProvidePlanInSpecifiedTime;

extern NSString * const kRequirementStatusUnorderAnyDesigner;
extern NSString * const kRequirementStatusOrderedDesignerWithoutAnyResponse;
extern NSString * const kRequirementStatusDesignerRespondedWithoutMeasureHouse;
extern NSString * const kRequirementStatusDesignerSubmittedPlanWithoutResponse;
extern NSString * const kRequirementStatusPlanWasChoosedWithoutAgreement;
extern NSString * const kRequirementStatusConfiguredWorkSite;
extern NSString * const kRequirementStatusDesignerMeasureHouseWithoutPlan;
extern NSString * const kRequirementStatusConfiguredAgreementWithoutWorkSite;
extern NSString * const kRequirementStatusFinishedWorkSite;

extern NSString * const kAuthTypeUnsubmitVerify;
extern NSString * const kAuthTypeSubmitedVerifyButNotPass;
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

extern NSString * const kNotificationTypePurchase;
extern NSString * const kNotificationTypePay;
extern NSString * const kNotificationTypeReschedule;
extern NSString * const kNotificationTypeDBYS;
extern NSString * const kDecTypeHouse;
extern NSString * const kDecTypeBusiness;

extern NSString * const kWorkTypeHalf;
extern NSString * const kWorkTypeWhole;
extern NSString * const kWorkTypeDesign;

extern NSString * const kUserPNFromRescheduleRequest;
extern NSString * const kUserPNFromPurchaseTip;
extern NSString * const kUserPNFromPayTip;
extern NSString * const kUserPNFromDBYSRequest;
extern NSString * const kUserPNFromSystemMsg;
extern NSString * const kUserPNFromPlanComment;
extern NSString * const kUserPNFromDecItemComment;
extern NSString * const kUserPNFromOrderRespond;
extern NSString * const kUserPNFromOrderReject;
extern NSString * const kUserPNFromPlanSubmit;
extern NSString * const kUserPNFromAgreementConfigure;
extern NSString * const kUserPNFromRescheduleReject;
extern NSString * const kUserPNFromRescheduleAgree;
extern NSString * const kUserPNFromMeasureHouseConfirm;

extern NSString * const kDesignerPNFromRescheduleRequest;
extern NSString * const kDesignerPNFromPurchaseTip;
extern NSString * const kDesignerPNFromSystemMsg;
extern NSString * const kDesignerPNFromPlanComment;
extern NSString * const kDesignerPNFromDecItemComment;
extern NSString * const kDesignerPNFromBasicInfoAuthPass;
extern NSString * const kDesignerPNFromBasicInfoAuthNotPass;
extern NSString * const kDesignerPNFromIDAuthPass;
extern NSString * const kDesignerPNFromIDAuthNotPass;
extern NSString * const kDesignerPNFromWorksiteAuthPass;
extern NSString * const kDesignerPNFromWorksiteAuthNotPass;
extern NSString * const kDesignerPNFromProductAuthPass;
extern NSString * const kDesignerPNFromProductAuthNotPass;
extern NSString * const kDesignerPNFromProductBreakRule;
extern NSString * const kDesignerPNFromOrderTip;
extern NSString * const kDesignerPNFromMeasureHouseConfirm;
extern NSString * const kDesignerPNFromPlanChoose;
extern NSString * const kDesignerPNFromPlanNotChoose;
extern NSString * const kDesignerPNFromAgreementConfirm;
extern NSString * const kDesignerPNFromRescheduleReject;
extern NSString * const kDesignerPNFromRescheduleAgree;
extern NSString * const kDesignerPNFromDBYSConfirm;

extern NSString * const kDecPackageDefault;
extern NSString * const kDecPackage365;

extern NSString * const kDecProgressTakeALook;
extern NSString * const kDecProgressDoingPrepare;
extern NSString * const kDecProgressStartedAlready;
