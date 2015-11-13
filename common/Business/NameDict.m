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
    
    desginFeeDict = @{@"0":@"50 - 100",
                      @"1":@"100 - 200",
                      @"2":@"200 - 300",
                      @"3":@"300以上"};
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

@end

