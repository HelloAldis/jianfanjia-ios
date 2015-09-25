//
//  DesignerCDDao.m
//  jianfanjia
//
//  Created by JYZ on 15/9/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerCDDao.h"

@implementation DesignerCDDao

+ (DesignerCD *)findOneByDesignerid:(NSString *)designerid {
    NSManagedObjectContext *moc = [[CoreDataManager shared] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DesignerCD"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"designerid == %@", designerid]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (error) {
        DDLogError(@"error %@", error);
    }
    
    return [results firstObject];
}

+ (NSArray *)find {
    NSManagedObjectContext *moc = [[CoreDataManager shared] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DesignerCD"];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (error) {
        DDLogError(@"error %@", error);
    }
    
    return results;
}

+ (DesignerCD *)insertOne {
    DesignerCD *designerCD = [NSEntityDescription insertNewObjectForEntityForName:@"DesignerCD"
                                                   inManagedObjectContext:[[CoreDataManager shared] managedObjectContext]];
    return designerCD;
}

+ (void)insertOrUpdate:(Designer *)designer {
    DesignerCD *designerCD = [DesignerCDDao findOneByDesignerid:designer._id];
    
    if (designerCD) {
        [designerCD update:designer];
    } else {
        DesignerCD *designerCD = [DesignerCDDao insertOne];
        [designerCD update:designer];
    }
    
    [DesignerCDDao save];
}

@end
