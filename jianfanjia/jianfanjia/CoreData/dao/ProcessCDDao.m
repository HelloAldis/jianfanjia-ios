//
//  ProcessDao.m
//  jianfanjia
//
//  Created by JYZ on 15/9/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProcessCDDao.h"

@implementation ProcessCDDao

+ (ProcessCD *)findOneByProcessid:(NSString *)processid {
    NSManagedObjectContext *moc = [[CoreDataManager shared] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProcessCD"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"processid == %@", processid]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (error) {
        DDLogError(@"error %@", error);
    }
    
    return [results firstObject];
}

+ (NSArray *)find {
    NSManagedObjectContext *moc = [[CoreDataManager shared] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProcessCD"];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (error) {
        DDLogError(@"error %@", error);
    }
    
    return results;
}

+ (ProcessCD *)insertOne {
    ProcessCD *processCD = [NSEntityDescription insertNewObjectForEntityForName:@"ProcessCD"
                                                         inManagedObjectContext:[[CoreDataManager shared] managedObjectContext]];
    return processCD;
}

+ (void)insertOrUpdate:(Process *)process {
    ProcessCD *processCD = [ProcessCDDao findOneByProcessid:process._id];
    
    if (processCD) {
        [processCD update:process];
        [processCD setUserid:@"hahah userid"];
    } else {
        ProcessCD *processCD = [ProcessCDDao insertOne];
        [processCD update:process];
    }

    DDLogDebug(@"%@", [[[CoreDataManager shared] managedObjectContext] hasChanges] ? @"YES" : @"N0");
    
    [ProcessCDDao save];
}


@end
