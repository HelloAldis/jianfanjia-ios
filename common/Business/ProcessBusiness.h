//
//  ProcessBusiness.h
//  jianfanjia
//
//  Created by JYZ on 15/10/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const KAI_GONG;
extern NSString * const CHAI_GAI;
extern NSString * const SHUI_DIAN;
extern NSString * const NI_MU;
extern NSString * const YOU_QI;
extern NSString * const AN_ZHUANG;
extern NSString * const JUN_GONG;
extern NSString * const DBYS;

@class Process;

@interface ProcessBusiness : NSObject

+ (Process *)defaultProcess;
+ (NSString *)nameForKey:(NSString *)key;
+ (BOOL)hasYs:(NSInteger)sectionIndex;
+ (NSArray *)allSectionName;

@end
