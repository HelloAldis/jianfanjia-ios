//
//  Bc.m
//  jianfanjia
//
//  Created by JYZ on 15/10/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Bc.h"

/**
 Keychain
 */
NSString * const kKeychainService = @"com.jianfanjia.jianfanjia";


int const kWelcomeVersion = 2;
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
NSString * const kPlanStatusExpiredAsDesignerDidNotProvidePlanInSpecifiedTime = @"8";

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
 * 8. 工地已完工
 
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
NSString * const kRequirementStatusFinishedWorkSite = @"8";


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
NSString * const kTopicTypeProcess = @"1";


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

/*
 推送消息类型 message_type
 * 0. 延期提醒
 * 1. 采购提醒
 * 2. 付款提醒
 * 3. 对比验收
 **/
NSString * const kNotificationTypeReschedule = @"0";
NSString * const kNotificationTypePurchase = @"1"; 
NSString * const kNotificationTypePay = @"2";
NSString * const kNotificationTypeDBYS = @"3";

/*
 装修类型 dec_type
 * 0. 家装
 * 1. 商装
 **/
NSString * const kDecTypeHouse = @"0";
NSString * const kDecTypeBusiness = @"1";

/*
 装修类型 work_type
 * 0. 半包
 * 1. 全包
 * 2. 纯设计
 **/
NSString * const kWorkTypeHalf = @"0";
NSString * const kWorkTypeWhole = @"1";
NSString * const kWorkTypeDesign = @"2";


/*
 业主的消息类型 user_message_type
 * 0. 设计师提出改期提醒
 * 1. 采购提醒
 * 2. 付款提醒
 * 3. 验收提醒
 * 4. 平台通知
 * 5. 方案评论
 * 6. 装修小节点评论
 * 7. 设计师响应
 * 8. 设计师拒绝
 * 9. 设计师上传了方案
 * 10. 设计师配置了合同
 * 11. 设计师拒绝改期
 * 12. 设计师同意改期
 * 13. 提醒业主确认量房
 **/
//PN - Push Notification
NSString * const kUserPNFromRescheduleRequest = @"0";
NSString * const kUserPNFromPurchaseTip = @"1";
NSString * const kUserPNFromPayTip = @"2";
NSString * const kUserPNFromDBYSRequest = @"3";
NSString * const kUserPNFromSystemMsg = @"4";
NSString * const kUserPNFromPlanComment = @"5";
NSString * const kUserPNFromDecItemComment = @"6";
NSString * const kUserPNFromOrderRespond = @"7";
NSString * const kUserPNFromOrderReject = @"8";
NSString * const kUserPNFromPlanSubmit = @"9";
NSString * const kUserPNFromAgreementConfigure = @"10";
NSString * const kUserPNFromRescheduleReject = @"11";
NSString * const kUserPNFromRescheduleAgree = @"12";
NSString * const kUserPNFromMeasureHouseConfirm = @"13";

/*
 设计师的消息类型 designer_message_type
 * 0. 改期提醒
 * 1. 采购提醒
 * 2. 平台通知
 * 3. 方案评论
 * 4. 装修小节点评论
 * 5. 基本信息审核通过
 * 6. 基本信息审核不通过
 * 7. 身份证和银行卡审核通过
 * 8. 身份证和银行卡审核不通过
 * 9. 工地审核通过
 * 10. 工地审核不通过
 * 11. 作品审核通过
 * 12. 作品审核不通过
 * 13. 作品违规被下线
 * 14. 业主预约提醒
 * 15. 业主确认量房提醒
 * 16. 方案中标消息
 * 17. 方案未中标消息
 * 18. 业主确认合同消息
 * 19. 业主拒绝改期
 * 20. 业主师同意改期
 * 21. 业主确认对比验收
 **/
NSString * const kDesignerPNFromRescheduleRequest = @"0";
NSString * const kDesignerPNFromPurchaseTip = @"1";
NSString * const kDesignerPNFromSystemMsg = @"2";
NSString * const kDesignerPNFromPlanComment = @"3";
NSString * const kDesignerPNFromDecItemComment = @"4";
NSString * const kDesignerPNFromBasicInfoAuthPass = @"5";
NSString * const kDesignerPNFromBasicInfoAuthNotPass = @"6";
NSString * const kDesignerPNFromIDAuthPass = @"7";
NSString * const kDesignerPNFromIDAuthNotPass = @"8";
NSString * const kDesignerPNFromWorksiteAuthPass = @"9";
NSString * const kDesignerPNFromWorksiteAuthNotPass = @"10";
NSString * const kDesignerPNFromProductAuthPass = @"11";
NSString * const kDesignerPNFromProductAuthNotPass = @"12";
NSString * const kDesignerPNFromProductBreakRule = @"13";
NSString * const kDesignerPNFromOrderTip = @"14";
NSString * const kDesignerPNFromMeasureHouseConfirm = @"15";
NSString * const kDesignerPNFromPlanChoose = @"16";
NSString * const kDesignerPNFromPlanNotChoose = @"17";
NSString * const kDesignerPNFromAgreementConfirm = @"18";
NSString * const kDesignerPNFromRescheduleReject = @"19";
NSString * const kDesignerPNFromRescheduleAgree = @"20";
NSString * const kDesignerPNFromDBYSConfirm = @"21";

/*
 需求的包类型 package_type
 * 0. 默认包
 * 1. 365块每平米基础包
 **/
NSString * const kDecPackageDefault = @"0";
NSString * const kDecPackage365 = @"1";





