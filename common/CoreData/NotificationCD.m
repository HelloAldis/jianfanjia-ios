//
//  NotificationCD.m
//  
//
//  Created by JYZ on 15/12/2.
//
//

#import "NotificationCD.h"
#import "NotificationToData.h"

@implementation NotificationCD

// Insert code here to add functionality to your managed object subclass

+ (void)initialize {
    NotificationToData *transformer = [[NotificationToData alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:@"NotificationToData"];
}


+ (void)insertOrUpdate:(BaseDynamicObject *)bdo {
    NotificationCD *notificationCD = [NotificationCD insertOne];
    notificationCD.info = [bdo data];
    //TODO set others
    
    [NSManagedObjectContext save];
}


@end
