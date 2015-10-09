//
//  NSManagedObjectContext+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/9/29.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "NSManagedObjectContext+Ex.h"
#import "CoreDataManager.h"

@implementation NSManagedObjectContext (Ex)

+ (NSManagedObjectContext *)context {
    return [[CoreDataManager shared] managedObjectContext];
}

+ (void)save {
    [[CoreDataManager shared] saveContext];
}

@end
