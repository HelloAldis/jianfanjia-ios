//
//  RequirementBusiness.m
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

/**
 优先判断匠心定制包
 
 匠心定制	家装          商装
 半包	>=1000元/平米	 敬请期待
 全包	>=2500元/平米	 敬请期待
 纯设计	>=200元/平米  敬请期待
 
 365包
 半包／全包 面积要在80~120(包含80和120)
 **/

#import "RequirementBusiness.h"
#import "StatusBlock.h"

static NSString * const kPkg365Name = @"365基础包";

@implementation RequirementBusiness

#pragma mark - pkg 365
+ (BOOL)isPkgJiangXinByType:(NSString *)type {
    return [type isEqualToString:kDecPackageJiangXinDingZhi];
}

+ (BOOL)isPkg365ByType:(NSString *)type {
    return [type isEqualToString:kDecPackage365];
}

+ (BOOL)isPkg365ByArea:(NSUInteger)area {
    if (area >= 80 && area <= 120) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)getPkgTypeByArea:(CGFloat)area budget:(CGFloat)budget workType:(NSString *)workType {
    CGFloat pricePerM = budget * 10000.0f/ area;
    
    if ([workType isEqualToString:kWorkTypeHalf] && pricePerM >= 1000.0f) {
        return kDecPackageJiangXinDingZhi;
    } else if ([workType isEqualToString:kWorkTypeWhole] && pricePerM >= 2500.0f) {
        return kDecPackageJiangXinDingZhi;
    } else if ([workType isEqualToString:kWorkTypeDesign] && pricePerM >= 200.0f) {
        return kDecPackageJiangXinDingZhi;
    }
    
    if ([self isPkg365ByArea:area] && ![self isDesignRequirement:workType]) {
        return kDecPackage365;
    }
    
    return kDecPackageDefault;
}

+ (CGFloat)getPkgWPriceByArea:(NSUInteger)area {
    if ([self isPkg365ByArea:area]) {
        return area * 365.0f / 10000.0f;
    }
    
    return 0.0f;
}

+ (CGFloat)getPkgPriceByArea:(NSUInteger)area {
    if ([self isPkg365ByArea:area]) {
        return area * 365.0f;
    }
    
    return 0.0f;
}

+ (PriceItem *)findPriceItem365:(NSArray <PriceItem *> *)array {
    __block PriceItem *findItem = nil;
    [array enumerateObjectsUsingBlock:^(PriceItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isPriceItem365:obj]) {
            findItem = obj;
            *stop = YES;
        }
    }];
    
    return findItem;
}

+ (BOOL)isPriceItem365:(PriceItem *)item {
    return [item.item isEqualToString:kPkg365Name];
}

+ (BOOL)isDesignRequirement:(NSString *)workType {
    return [workType isEqualToString:kWorkTypeDesign];
}

@end
