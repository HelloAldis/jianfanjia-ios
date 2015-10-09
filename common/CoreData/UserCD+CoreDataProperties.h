//
//  UserCD+CoreDataProperties.h
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userid;
@property (nullable, nonatomic, retain) id user;

@end

NS_ASSUME_NONNULL_END
