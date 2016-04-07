//
//  RequirementBusiness.m
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementBusiness.h"

@implementation RequirementBusiness

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

+ (CGFloat)getPkgPriceByArea:(NSUInteger)area {
    if ([self isPkg365ByArea:area]) {
        return area * 365.0f / 10000.0f;
    }
    
    return 0.0f;
}

@end
