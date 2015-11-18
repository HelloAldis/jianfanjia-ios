//
//  Bc.m
//  jianfanjia
//
//  Created by JYZ on 15/10/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Bc.h"

int const kWelconeVersion = 1;
int const kPhoneLength = 11;
int const kPasswordLength = 30;

NSString * const kUserTypeUser = @"1";
NSString * const kUserTypeDesigner = @"2";

NSString * const kProcessItemStatusNew = @"0";
NSString * const kProcessItemStatusGoing = @"1";
NSString * const kProcessItemStatusDone = @"2";
NSString * const kProcessItemStatusRescheduleReqNew = @"3";
NSString * const kProcessItemStatusRescheduleOk = @"4";
NSString * const kProcessItemStatusRescheduleReject = @"5";


NSUInteger const kMaxOrderableDesignerCount = 3;

/**
 预约方案状态 plan status
 * 0. 已预约但没有响应
 * 1. 已拒绝业主
 * 2. 已响应但是没有确认量房
 * 3. 提交了方案
 * 4. 方案被未中标
 * 5. 方案被选中
 * 6. 已确认量房但是没有方案
 * 7. 设计师无响应导致响应过期
 * 8. 设计师规定时间内没有上场方案，过期
 
 <string-array name="plan_status">
 <item>已预约</item>
 <item>已拒绝</item>
 <item>已响应</item>
 <item>有方案</item>
 <item>未中标</item>
 <item>已中标</item>
 <item>已量房</item>
 <item>未响应</item>
 <item>未提交</item>
 </string-array>
 **/
NSString * const kPlanStatusUnorder = @"-1";
NSString * const kPlanStatusHomeOwnerOrderedWithoutResponse = @"0";
NSString * const kPlanStatusDesignerDeclineHomeOwner = @"1";
NSString * const kPlanStatusDesignerRespondedWithoutMeasureHouse = @"2";
NSString * const kPlanStatusDesignerSubmittedPlan = @"3";
NSString * const kPlanStatusPlanWasNotChoosed = @"4";
NSString * const kPlanStatusPlanWasChoosed = @"5";
NSString * const kPlanStatusDesignerMeasureHouseWithoutPlan = @"6";
NSString * const kPlanStatusExpiredAsDesignerDidNotRespond = @"7";
NSString * const kPlanStatusExpiredAsDesignerDidProvidePlanInSpecifiedTime = @"8";

/**
 需求状态 requirement status
 * 0. 未预约任何设计师
 * 1. 预约过设计师但是没有一个设计师响应过
 * 2. 有一个或多个设计师响应但没有人量完房
 * 3. 有一个或多个设计师提交了方案但是没有选定方案
 * 4. 选定了方案但是还没有配置合同
 * 5. 配置了工地
 * 6. 有一个或多个设计师量完房但是没有人上传方案
 * 7. 配置了合同但是没有配置工地
 
 <string-array name="requirement_status">
 <item>未预约</item>
 <item>已预约</item>
 <item>已响应</item>
 <item>有方案</item>
 <item>已选定</item>
 <item>有工地</item>
 <item>已量房</item>
 <item>有合同</item>
 </string-array>
 **/

NSString * const kRequirementStatusUnorderAnyDesigner = @"0";
NSString * const kRequirementStatusOrderedDesignerWithoutAnyResponse = @"1";
NSString * const kRequirementStatusDesignerRespondedWithoutMeasureHouse = @"2";
NSString * const kRequirementStatusDesignerSubmittedPlanWithoutResponse = @"3";
NSString * const kRequirementStatusPlanWasChoosedWithoutAgreement = @"4";
NSString * const kRequirementStatusConfiguredWorkSite = @"5";
NSString * const kRequirementStatusDesignerMeasureHouseWithoutPlan = @"6";
NSString * const kRequirementStatusConfiguredAgreementWithoutWorkSite  = @"7";


/**
 作品认证状态 auth_type
 * 0. 未审核
 * 1. 审核通过
 * 2. 审核不通过
 * 3. 违规屏蔽
 **/
NSString * const kAuthTypeUnverify = @"0";
NSString * const kAuthTypeVerifyPass = @"1";
NSString * const kAuthTypeVerifyNotPass = @"2";
NSString * const kAuthTypeBreakRule  = @"3";


