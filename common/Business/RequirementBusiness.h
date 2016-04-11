//
//  RequirementBusiness.h
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kRequirementCreateNotification = @"RequirementCreateNotification";

@class PriceItem;
@class StatusBlock;

typedef NS_ENUM(NSInteger, DecPackageKind) {
    DecPackageKindDefault,
    DecPackageKind365,
};

@interface RequirementBusiness : NSObject

+ (BOOL)isPkg365ByType:(NSString *)type;
+ (BOOL)isPkg365ByArea:(NSUInteger)area;
+ (DecPackageKind)getPkgKindByArea:(NSUInteger)area;
+ (CGFloat)getPkgWPriceByArea:(NSUInteger)area;
+ (CGFloat)getPkgPriceByArea:(NSUInteger)area;
+ (PriceItem *)findPriceItem365:(NSArray <PriceItem *> *)array;
+ (BOOL)isPriceItem365:(PriceItem *)item;

+ (BOOL)isDesignRequirement:(NSString *)workType;

@end
