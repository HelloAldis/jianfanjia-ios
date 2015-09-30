//
//  NSManagedObject+Ex.h
//  jianfanjia
//
//  Created by JYZ on 15/9/29.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Ex)

+ (instancetype) findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (instancetype)insertOne;

@end
