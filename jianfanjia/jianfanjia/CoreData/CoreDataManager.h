//
//  CoreDataManager.h
//  AURA
//
//  Created by MacMiniS on 14-11-12.
//  Copyright (c) 2014年 AURA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(CoreDataManager)

- (void)saveContext;
- (NSManagedObjectContext *)managedObjectContext;

@end
