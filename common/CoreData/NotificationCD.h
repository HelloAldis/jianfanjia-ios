//
//  NotificationCD.h
//  
//
//  Created by JYZ on 15/12/2.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationCD : NSManagedObject

- (Notification *)notification;
+ (void)insert:(Notification *)notification;

+ (NSArray *)getNotifications;
+ (NSArray *)getNotificationsWithStatus:(NSString *)status;
+ (NSArray *)getNotificationsWithType:(NSString *)type status:(NSString *)status;
+ (NSArray *)getNotificationsWithProcess:(NSString *)processid type:(NSString *)type;
+ (NSArray *)getNotificationsWithProcess:(NSString *)processid type:(NSString *)type status:(NSString *)status;
+ (NSArray *)getNotificationsWithUser:(NSString *)userid process:(nullable NSString *)processid type:(nullable NSString *)type status:(nullable NSString *)status;

+ (NSUInteger)getNotificationsCountWithType:(NSString *)type status:(NSString *)status;
+ (NSUInteger)getNotificationsCountWithProcess:(NSString *)processid type:(NSString *)type status:(NSString *)status;
+ (NSUInteger)getNotificationsCountWithUser:(NSString *)userid process:(nullable NSString *)processid type:(nullable NSString *)type status:(nullable NSString *)status;

@end

NS_ASSUME_NONNULL_END

#import "NotificationCD+CoreDataProperties.h"
