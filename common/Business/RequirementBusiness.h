//
//  RequirementBusiness.h
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DecPackageKind) {
    DecPackageKindDefault,
    DecPackageKind365,
};

@interface RequirementBusiness : NSObject

+ (BOOL)isPkg365:(NSUInteger)area;
+ (DecPackageKind)getPkgKind:(NSUInteger)area;

@end
