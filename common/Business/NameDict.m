//
//  NameDict.m
//  jianfanjia
//
//  Created by JYZ on 15/10/29.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "NameDict.h"

@implementation NameDict

static NSDictionary *houseTypeDict = nil;
static NSDictionary *houseAreaDisplayDict = nil;
static NSDictionary *houseAreaValueDict = nil;
static NSDictionary *decStyleDict = nil;
static NSDictionary *decTypeDict = nil;
static NSDictionary *desginFeeDict = nil;
static NSDictionary *work_type = nil;
static NSDictionary *communication_type = nil;
static NSDictionary *sex_type = nil;
static NSArray *population_type = nil;
static NSArray *bank_type = nil;
static NSArray *good_at = nil;
static NSDictionary *planStatus = nil;
static NSDictionary *requirementStatus = nil;
static NSDictionary *productAuthType = nil;
static NSDictionary *authType = nil;
static NSDictionary *userType = nil;
static NSDictionary *sectionStatusDic = nil;
static NSArray *beautifulTypeArr = nil;
static NSDictionary *businessTypeDict = nil;
static NSArray *homeTypeArr = nil;
static NSDictionary *decLiveSectionDict = nil;
static NSDictionary *decProgressDict = nil;
static NSArray *desginerTagArr = nil;

+ (void)initialize {
    houseTypeDict = @{@"0":@"一室",
                      @"1":@"二室",
                      @"2":@"三室",
                      @"3":@"四室",
                      @"4":@"复式",
                      @"5":@"别墅",
                      @"6":@"LOFT",
                      @"7":@"其他"};
    
    houseAreaDisplayDict = @{@"0":@"90m²以下",
                             @"1":@"90 - 120m²",
                             @"2":@"120 - 150m²",
                             @"3":@"150 - 200m²",
                             @"4":@"200m²以上",};
    
    houseAreaValueDict = @{@"0":@{@"$lt": @90},
                           @"1":@{@"$gte": @90, @"$lt": @120},
                           @"2":@{@"$gte": @120, @"$lt": @150},
                           @"3":@{@"$gte": @150, @"$lt": @200},
                           @"4":@{@"$gte": @200},};
    
    decStyleDict = @{@"0":@"欧式",
                     @"1":@"中式",
                     @"2":@"现代",
                     @"3":@"地中海",
                     @"4":@"美式",
                     @"5":@"东南亚",
                     @"6":@"田园",};
    
    decTypeDict = @{kDecTypeHouse:@"家装",
                    kDecTypeBusiness:@"商装",
                    @"2":@"软装"};
    
    work_type = @{kWorkTypeHalf:@"半包",
                  kWorkTypeWhole:@"全包",
                  kWorkTypeDesign:@"纯设计"};
    
    population_type = @[@"单身", @"幸福小两口", @"三口之家", @"三代同堂", @"其他"];
    
    bank_type = @[@"中国工商银行", @"招商银行", @"中国农业银行", @"中国建设银行", @"中国银行", @"中国民生银行", @"中国光大银行", @"中信银行", @"交通银行", @"兴业银行", @"上海浦东发展银行", @"中国人民银行", @"华夏银行", @"国家开发银行", @"中国进出口银行", @"中国农业发展银行", @"北京银行", @"上海银行", @"中国邮政储蓄银行",];
    
    good_at = @[@"水电", @"木工", @"油工", @"泥工",];
    
    communication_type = @{@"0":@"不限",
                           @"1":@"表达型",
                           @"2":@"倾听型"};
    
    sex_type = @{@"0":@"男",
                 @"1":@"女",
                 @"2":@"不限"};
    
    
    desginFeeDict = @{@"0":@"50 - 100",
                      @"1":@"100 - 200",
                      @"2":@"200 - 300",
                      @"3":@"300以上"};
    
    desginerTagArr = @[
                  kDesignerTagXinYueXianFeng,
                  kDesignerTagNuanNuanZouXin,
                  kDesignerTagJiangXinDingZhi,];

    planStatus = @{
                   kPlanStatusHomeOwnerOrderedWithoutResponse:@"等待响应",
                   kPlanStatusDesignerDeclineHomeOwner:@"已拒绝",
                   kPlanStatusDesignerRespondedWithoutMeasureHouse:@"等待量房",
                   kPlanStatusDesignerSubmittedPlan:@"等待确认方案",
                   kPlanStatusPlanWasNotChoosed:@"未中标",
                   kPlanStatusPlanWasChoosed:@"已中标",
                   kPlanStatusDesignerMeasuredHouseWithoutPlan:@"等待上传方案",
                   kPlanStatusDesignerRespondExpired:@"未响应",
                   kPlanStatusDesignerSubmitPlanExpired:@"未提交",
                   kPlanStatusExpired:@"已过期"
                   };
    
    requirementStatus = @{
                          kRequirementStatusUnorderAnyDesigner:@"未预约",
                          kRequirementStatusOrderedDesignerWithoutAnyResponse:@"已预约",
                          kRequirementStatusDesignerRespondedWithoutMeasureHouse:@"已响应",
                          kRequirementStatusDesignerSubmittedPlanWithoutResponse:@"已有方案",
                          kRequirementStatusPlanWasChoosedWithoutAgreement:@"已选定",
                          kRequirementStatusConfiguredWorkSite:@"有工地",
                          kRequirementStatusDesignerMeasureHouseWithoutPlan:@"已量房",
                          kRequirementStatusConfiguredAgreementWithoutWorkSite:@"有合同",
                          kRequirementStatusFinishedWorkSite:@"已竣工",
                          };
    
    authType = @{
                kAuthTypeUnsubmitVerify:@"前往认证",
                kAuthTypeSubmitedVerifyButNotPass:@"认证中",
                kAuthTypeVerifyPass:@"认证成功",
                kAuthTypeVerifyNotPass:@"认证失败",
                kAuthTypeBreakRule:@"违规屏蔽"
                };
    
    productAuthType = @{
                 kProductAuthTypeUnsubmitVerify:@"认证中",
                 kProductAuthTypeVerifyPass:@"认证成功",
                 kProductAuthTypeVerifyNotPass:@"认证失败",
                 kProductAuthTypeBreakRule:@"违规屏蔽"
                 };
    
    userType = @{
                 @"0":@"管理员",
                 @"1":@"业主",
                 @"2":@"设计师",
                 @"3":@"监理"
                 };
    
    sectionStatusDic = @{
                         @"0":@"未开工",
                         @"1":@"进行中",
                         @"2":@"已完工",
                         @"3":@"改期申请中",
                         @"4":@"改期同意",
                         @"5":@"改期拒绝",
                         };
    
    beautifulTypeArr = @[@"厨房",
                         @"客厅",
                         @"卫生间",
                         @"卧室",
                         @"餐厅",
                         @"书房",
                         @"玄关",
                         @"阳台",
                         @"儿童房",
                         @"走廊",
                         @"储物间",];
    
    homeTypeArr = @[@"厨房",
                     @"客厅",
                     @"卫生间",
                     @"卧室",
                     @"餐厅",
                     @"书房",
                     @"玄关",
                     @"阳台",
                     @"儿童房",
                     @"走廊",
                     @"储物间",];
    
    businessTypeDict = @{
                         @"0":@"餐厅",
                         @"1":@"服装店",
                         @"2":@"酒吧",
                         @"3":@"美容院",
                         @"4":@"办公室",
                         @"5":@"美发店",
                         @"6":@"幼儿园",
                         @"7":@"酒店",
                         @"9999":@"其他",};
    
    decLiveSectionDict = @{
                           @"0":@"量房",
                           @"1":@"开工",
                           @"2":@"拆改",
                           @"3":@"水电",
                           @"4":@"泥木",
                           @"5":@"油漆",
                           @"6":@"安装",
                           @"7":@"竣工",
                           };
    decProgressDict = @{
                       kDecProgressTakeALook:@"我想看一看",
                       kDecProgressDoingPrepare:@"正在做准备",
                       kDecProgressStartedAlready:@"已经开始装修",
                       };
}

+ (NSDictionary *)getAllHouseType {
    return houseTypeDict;
}

+ (NSDictionary *)getAllDisplayHouseArea {
    return houseAreaDisplayDict;
}

+ (NSDictionary *)getAllValueHouseArea {
    return houseAreaValueDict;
}

+ (NSDictionary *)getAllDecorationStyle {
    return decStyleDict;
}

+ (NSDictionary *)getAllDecorationType {
    return decTypeDict;
}

+ (NSArray *)getAllPopulationType {
    return population_type;
}

+ (NSArray *)getAllBankType {
    return bank_type;
}

+ (NSArray *)getAllGoodAt {
    return good_at;
}

+ (NSDictionary *)getAllWorkType {
    return work_type;
}

+ (NSDictionary *)getAllSexType {
    return sex_type;
}

+ (NSDictionary *)getAllAuthType {
    return authType;
}

+ (NSDictionary *)getAllPlanStatus {
    return planStatus;
}

+ (NSDictionary *)getAllRequirementStatus {
    return requirementStatus;
}

+ (NSDictionary *)getAllCommunicationType {
    return communication_type;
}

+ (NSArray *)getAllBeautifulImageType {
    return beautifulTypeArr;
}

+ (NSArray *)getAllHomeType {
    return homeTypeArr;
}

+ (NSDictionary *)getAllBusinessType {
    return businessTypeDict;
}

+ (NSDictionary *)getAllDesignFee {
    return desginFeeDict;
}

+ (NSArray *)getAllDesignerTag {
    return desginerTagArr;
}

+ (NSString *)nameForUserType:(NSString *)type {
    return [userType objectForKey:type];
}

+ (NSString *)nameForHouseType:(NSString *)type {
    return [houseTypeDict objectForKey:type];
}

+ (NSString *)nameForDecStyle:(NSString *)style {
    return [decStyleDict objectForKey:style];
}

+ (NSString *)nameForDecType:(NSString *)type {
    return [decTypeDict objectForKey:type];
}

+ (NSString *)nameForDesignerFee:(NSString *)design_fee {
    return [desginFeeDict objectForKey:design_fee];
}

+ (NSString *)nameForWorkType:(NSString *)type {
    return [work_type objectForKey:type];
}

+ (NSString *)nameForCommunicationType:(NSString *)type {
    return [communication_type objectForKey:type];
}

+ (NSString *)nameForSexType:(NSString *)type {
    return [sex_type objectForKey:type];
}

+ (NSString *)nameForAuthType:(NSString *)type {
    return [authType objectForKey:type];
}

+ (NSString *)nameForProductAuthType:(NSString *)type {
    return [productAuthType objectForKey:type];
}

+ (NSString *)nameForPlanStatus:(NSString *)status {
    return [planStatus objectForKey:status];
}

+ (NSString *)nameForRequirementStatus:(NSString *)status {
    return [requirementStatus objectForKey:status];
}

+ (NSString *)nameForSectionStatus:(NSString *)status {
    return [sectionStatusDic objectForKey:status];
}

+ (NSString *)nameForBusinessType:(NSString *)status {
    return [businessTypeDict objectForKey:status];
}

+ (NSString *)nameForDecLiveSectionType:(NSString *)status {
    return [decLiveSectionDict objectForKey:status];
}

+ (NSString *)nameForDecProgress:(NSString *)status {
    return [decProgressDict objectForKey:status];
}

@end