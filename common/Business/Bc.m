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

/**
 角色 role:
 * 0. 管理员
 * 1. 业主
 * 2. 设计师
 **/
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
 认证状态 包括基本信息认证(auth_type) 身份认证(uid_auth_type) 邮箱认证(email_auth_type) 工地认证(work_auth_type)
 * 0. 未提交认证
 * 1. 提交认证还未审核过
 * 2. 审核通过
 * 3. 审核不通过
 * 4. 违规屏蔽
 **/
NSString * const kAuthTypeUnsubmitVerify = @"0";
NSString * const kAuthTypeSubmitedVerifyButNotPass = @"1";
NSString * const kAuthTypeVerifyPass = @"2";
NSString * const kAuthTypeVerifyNotPass = @"3";
NSString * const kAuthTypeBreakRule  = @"4";


/**
 评论类别 topictype
 * 0. 方案的评论
 * 1. 装修流程的小点的评论
**/
NSString * const kTopicTypePlan = @"0";
NSString * const kTopicTypeSection = @"1";


/**
 流程状态 section status
 * 0. 未开工
 * 1. 进行中
 * 2. 已完成
 * 3. 改期申请中
 * 4. 改期同意
 * 5. 改期拒绝
**/
NSString * const kSectionStatusUnStart = @"0";
NSString * const kSectionStatusOnGoing = @"1";
NSString * const kSectionStatusAlreadyFinished = @"2";
NSString * const kSectionStatusChangeDateRequest = @"3";
NSString * const kSectionStatusChangeDateAgree = @"4";
NSString * const kSectionStatusChangeDateDecline = @"5";

 
