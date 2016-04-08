//
//  RequirementBusiness.m
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementBusiness.h"
#import "StatusBlock.h"

static NSString * const kPkg365Name = @"365基础包";

@implementation RequirementBusiness

#pragma mark - pkg 365
+ (BOOL)isPkg365ByType:(NSString *)type {
    return [type isEqualToString:kDecPackage365];
}

+ (BOOL)isPkg365ByArea:(NSUInteger)area {
    return [self getPkgKindByArea:area] == DecPackageKind365;
}

+ (DecPackageKind)getPkgKindByArea:(NSUInteger)area {
    if (area >= 80 && area <= 120) {
        return DecPackageKind365;
    }
    
    return DecPackageKindDefault;
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
