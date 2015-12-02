//
//  ProcessBusiness.h
//  jianfanjia
//
//  Created by JYZ on 15/10/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const DBYS;

@class Process;

@interface ProcessBusiness : NSObject

+ (Process *)defaultProcess;
+ (NSString *)nameForKey:(NSString *)key;
+ (BOOL)hasYs:(NSInteger)sectionIndex;

@end
