//
//  UserCDDao.m
//  jianfanjia
//
//  Created by JYZ on 15/9/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UserCDDao.h"
#import "CoreDataManager.h"

@implementation UserCDDao

+ (UserCD *)findOneByUserid:(NSString *)userid {
    NSManagedObjectContext *moc = [[CoreDataManager shared] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserCD"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userid == %@", userid]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (error) {
        DDLogError(@"error %@", error);
    }
    
    return [results firstObject];
}

+ (NSArray *)find {
    NSManagedObjectContext *moc = [[CoreDataManager shared] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserCD"];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (error) {
        DDLogError(@"error %@", error);
    }
    
    return results;
}

+ (UserCD *)insertOne {
    UserCD *userCD = [NSEntityDescription insertNewObjectForEntityForName:@"UserCD"
                                                         inManagedObjectContext:[[CoreDataManager shared] managedObjectContext]];
    return userCD;
}

+ (void)insertOrUpdate:(User *)user {
    UserCD *userCD = [UserCDDao findOneByUserid:user._id];
    
    if (userCD) {
        [userCD update:user];
    } else {
        UserCD *userCD = [UserCDDao insertOne];
        [userCD update:user];
    }
    
    [UserCDDao save];
}

@end
