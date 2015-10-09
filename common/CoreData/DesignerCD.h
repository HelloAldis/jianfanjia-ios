//
//  DesignerCD.h
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Designer.h"

NS_ASSUME_NONNULL_BEGIN

@interface DesignerCD : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (void)update:(Designer *)designer;
+ (void)insertOrUpdate:(Designer *)designer;

@end

NS_ASSUME_NONNULL_END

#import "DesignerCD+CoreDataProperties.h"
