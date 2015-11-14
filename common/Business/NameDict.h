//
//  NameDict.h
//  jianfanjia
//
//  Created by JYZ on 15/10/29.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameDict : NSObject

+ (NSDictionary *)getAllHouseType;
+ (NSDictionary *)getAllDecorationStyle;
+ (NSDictionary *)getAllDecorationType;
+ (NSArray *)getAllPopulationType;
+ (NSDictionary *)getAllCommunicationType;
+ (NSDictionary *)getAllWorkType;
+ (NSDictionary *)getAllSexType;

+ (NSString *)nameForHouseType:(NSString *)type;
+ (NSString *)nameForDecStyle:(NSString *)style;
+ (NSString *)nameForDecType:(NSString *)type;
+ (NSString *)nameForDesignerFee:(NSString *)design_fee;
+ (NSString *)nameForWorkType:(NSString *)type;
+ (NSString *)nameForCommunicationType:(NSString *)type;
+ (NSString *)nameForSexType:(NSString *)type;

@end
