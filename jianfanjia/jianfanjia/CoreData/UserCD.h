//
//  UserCD.h
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCD : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (void)update:(User *)user;
+ (void)insertOrUpdate:(User *)user;

@end

NS_ASSUME_NONNULL_END

#import "UserCD+CoreDataProperties.h"
