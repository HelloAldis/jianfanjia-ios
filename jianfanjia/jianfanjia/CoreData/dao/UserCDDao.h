//
//  UserCDDao.h
//  jianfanjia
//
//  Created by JYZ on 15/9/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseDao.h"
#import "UserCD.h"

@interface UserCDDao : BaseDao

+ (UserCD *)findOneByUserid:(NSString *)userid;
+ (NSArray *)find;
+ (UserCD *)insertOne;
+ (void)insertOrUpdate:(User *)user;

@end
