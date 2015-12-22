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
+ (NSDictionary *)getAllAuthType;
+ (NSDictionary *)getAllPlanStatus;
+ (NSDictionary *)getAllRequirementStatus;
+ (NSArray *)getAllBeautifulImageType;

+ (NSString *)nameForUserType:(NSString *)type;
+ (NSString *)nameForHouseType:(NSString *)type;
+ (NSString *)nameForDecStyle:(NSString *)style;
+ (NSString *)nameForDecType:(NSString *)type;
+ (NSString *)nameForDesignerFee:(NSString *)design_fee;
+ (NSString *)nameForWorkType:(NSString *)type;
+ (NSString *)nameForCommunicationType:(NSString *)type;
+ (NSString *)nameForSexType:(NSString *)type;
+ (NSString *)nameForAuthType:(NSString *)type;
+ (NSString *)nameForPlanStatus:(NSString *)status;
+ (NSString *)nameForRequirementStatus:(NSString *)status;
+ (NSString *)nameForSectionStatus:(NSString *)status;

@end
