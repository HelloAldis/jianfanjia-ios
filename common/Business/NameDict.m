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
static NSDictionary *decStyleDict = nil;
static NSDictionary *decTypeDict = nil;
static NSDictionary *desginFeeDict = nil;
static NSDictionary *work_type = nil;
static NSDictionary *communication_type = nil;
static NSDictionary *sex_type = nil;
static NSArray *population_type = nil;


+ (void)initialize {
    houseTypeDict = @{@"0":@"一居",
                      @"1":@"二居",
                      @"2":@"三居",
                      @"3":@"四居",
                      @"4":@"复式",
                      @"5":@"别墅",
                      @"6":@"LOFT",
                      @"7":@"其他"};
    
    decStyleDict = @{@"0":@"欧式",
                     @"1":@"中式",
                     @"2":@"现代",
                     @"3":@"地中海",
                     @"4":@"美式",
                     @"5":@"东南亚",
                     @"6":@"田园",};
    
    decTypeDict = @{@"0":@"家装",
                    @"1":@"商装",
                    @"2":@"软装"};
    
    work_type = @{@"0":@"设计＋施工(半包)",
                  @"1":@"设计＋施工(全包)",
                  @"2":@"纯设计"};
    
    population_type = @[@"单身", @"幸福小两口", @"三口之家", @"三代同堂", @"其他"];
    
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
}

+ (NSDictionary *)getAllHouseType {
    return houseTypeDict;
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

+ (NSDictionary *)getAllWorkType {
    return work_type;
}

+ (NSDictionary *)getAllSexType {
    return sex_type;
}

+ (NSDictionary *)getAllCommunicationType {
    return communication_type;
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

@end

