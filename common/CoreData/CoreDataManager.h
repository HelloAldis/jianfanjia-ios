//
//  CoreDataManager.h
//  AURA
//
//  Created by MacMiniS on 14-11-12.
//  Copyright (c) 2014年 AURA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

kSynthesizeSingletonForHeader(CoreDataManager)

- (void)saveContext;
- (NSManagedObjectContext *)managedObjectContext;

@end
