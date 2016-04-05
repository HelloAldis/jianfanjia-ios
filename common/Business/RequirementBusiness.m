//
//  RequirementBusiness.m
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementBusiness.h"

@implementation RequirementBusiness

+ (BOOL)isPkg365:(NSUInteger)area {
    return [self getPkgKind:area] == DecPackageKind365;
}

+ (DecPackageKind)getPkgKind:(NSUInteger)area {
    if (area >= 80 && area <= 120) {
        return DecPackageKind365;
    }
    
    return DecPackageKindDefault;
}

@end
