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

+ (void)initialize {
    NotificationToData *transformer = [[NotificationToData alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:@"NotificationToData"];
}

+ (void)insert:(Notification *)notification {
    NotificationCD *notificationCD = [NotificationCD insertOne];
    notificationCD.userid = notification.userid;
    notificationCD.processid = notification.processid;
    notificationCD.type = notification.type;
    notificationCD.time = notification.time;
    notificationCD.status = notification.status;
    notificationCD.info = [notification data];
    
    [NSManagedObjectContext save];
}

#pragma mark - get notification
+ (NSArray *)getNotificationsWithStatus:(NSString *)status {
    return [self getNotificationsWithUser:[GVUserDefaults standardUserDefaults].userid process:nil type:nil status:status];
}

+ (NSArray *)getNotificationsWithType:(NSString *)type status:(NSString *)status {
    return [self getNotificationsWithUser:[GVUserDefaults standardUserDefaults].userid process:nil type:type status:status];
}

+ (NSArray *)getNotificationsWithProcess:(NSString *)processid type:(NSString *)type status:(NSString *)status {
    return [self getNotificationsWithUser:[GVUserDefaults standardUserDefaults].userid process:processid type:type status:status];
}

+ (NSArray *)getNotificationsWithUser:(NSString *)userid process:(NSString *)processid type:(NSString *)type status:(NSString *)status {
    NSFetchRequest *request = [self generateRequestWithUser:userid process:processid type:type status:status];
    return [NSManagedObject executeFetchRequest:request];
}

#pragma mark - get notification count
+ (NSUInteger)getNotificationsCountWithType:(NSString *)type status:(NSString *)status {
    return [self getNotificationsCountWithUser:[GVUserDefaults standardUserDefaults].userid process:nil type:type status:status];
}

+ (NSUInteger)getNotificationsCountWithProcess:(NSString *)processid type:(NSString *)type status:(NSString *)status {
    return [self getNotificationsCountWithUser:[GVUserDefaults standardUserDefaults].userid process:processid type:type status:status];
}

+ (NSUInteger)getNotificationsCountWithUser:(NSString *)userid process:(NSString *)processid type:(NSString *)type status:(NSString *)status {
    NSFetchRequest *request = [self generateRequestWithUser:userid process:processid type:type status:status];
    return [NSManagedObject executeCountForFetchRequest:request];
}

#pragma mark - generate request
+ (NSFetchRequest *)generateRequestWithUser:(NSString *)userid process:(NSString *)processid type:(NSString *)type status:(NSString *)status {
    NSFetchRequest *request;
    NSMutableString *where = [NSMutableString string];
    NSMutableArray *args = [NSMutableArray array];
    
    if (userid) {
        [where appendString:@" userid = %@ "];
        [args addObject:userid];
    }
    
    if (processid) {
        [where appendString:@" AND processid = %@ "];
        [args addObject:processid];
    }
    
    if (type) {
        [where appendString:@" AND type = %@ "];
        [args addObject:type];
    }
    
    if (status) {
        [where appendString:@" AND status = %@ "];
        [args addObject:status];
    }
    
    request = [NotificationCD requestAllWhere:where args:args];
    return request;
}

@end
