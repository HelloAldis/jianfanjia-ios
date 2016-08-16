//
//  RequirementBusiness.h
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PriceItem;
@class StatusBlock;

@interface RequirementBusiness : NSObject

+ (BOOL)isPkgJiangXinByType:(NSString *)type;
+ (BOOL)isPkg365ByType:(NSString *)type;
+ (BOOL)isPkg365ByArea:(NSUInteger)area;
+ (NSString *)getPkgTypeByArea:(CGFloat)area budget:(CGFloat)budget workType:(NSString *)workType;
+ (CGFloat)getPkgWPriceByArea:(NSUInteger)area;
+ (CGFloat)getPkgPriceByArea:(NSUInteger)area;
+ (PriceItem *)findPriceItem365:(NSArray <PriceItem *> *)array;
+ (BOOL)isPriceItem365:(PriceItem *)item;

+ (BOOL)isDesignRequirement:(NSString *)workType;

@end
