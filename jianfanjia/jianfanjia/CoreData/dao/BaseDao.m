//
//  BaseDao.m
//  jianfanjia
//
//  Created by JYZ on 15/9/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseDao.h"

@implementation BaseDao

+ (void)save {
    [[CoreDataManager shared] saveContext];
}

@end
