//
//  NotificationCD+CoreDataProperties.h
//  jianfanjia
//
//  Created by JYZ on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NotificationCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSNumber *time;
@property (nullable, nonatomic, retain) id info;
@property (nullable, nonatomic, retain) NSString *status;

@end

NS_ASSUME_NONNULL_END
