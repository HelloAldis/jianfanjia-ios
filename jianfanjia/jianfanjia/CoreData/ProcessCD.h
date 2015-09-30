//
//  ProcessCD.h
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Process.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProcessCD : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (void)update:(Process *)process;
+ (void)insertOrUpdate:(Process *)process;

@end

NS_ASSUME_NONNULL_END

#import "ProcessCD+CoreDataProperties.h"
