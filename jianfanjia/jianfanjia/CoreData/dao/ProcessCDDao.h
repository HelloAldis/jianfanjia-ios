//
//  ProcessDao.h
//  jianfanjia
//
//  Created by JYZ on 15/9/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseDao.h"
#import "ProcessCD.h"

@interface ProcessCDDao : BaseDao

+ (ProcessCD *)findOneByProcessid:(NSString *)processid;
+ (NSArray *)find;
+ (ProcessCD *)insertOne;
+ (void)insertOrUpdate:(Process *)process;

@end
