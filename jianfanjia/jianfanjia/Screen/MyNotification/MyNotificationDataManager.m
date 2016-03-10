//
//  ReminderDataManager.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MyNotificationDataManager.h"

@implementation MyNotificationDataManager

- (NSInteger)refreshAllNotifications {
    NSMutableArray *array = nil;
    NSInteger count = [self refresh:&array];
    self.allNotifications = array;
    
    return count;
}

- (NSInteger)loadMoreAllNotifications {
    NSMutableArray *array = self.allNotifications;
    NSInteger count = [self loadMore:&array];
    self.allNotifications = array;
    
    return count;
}

- (NSInteger)refreshSystemAnnouncements {
    NSMutableArray *array = nil;
    NSInteger count = [self refresh:&array];
    self.systemAnnouncements = array;
    
    return count;
}

- (NSInteger)loadMoreSystemAnnouncements {
    NSMutableArray *array = self.systemAnnouncements;
    NSInteger count = [self loadMore:&array];
    self.systemAnnouncements = array;
    
    return count;
}

- (NSInteger)refreshRequirmentNotifications {
    NSMutableArray *array = nil;
    NSInteger count = [self refresh:&array];
    self.requirmentNotifications = array;
    
    return count;
}

- (NSInteger)loadMoreRequirmentNotifications {
    NSMutableArray *array = self.requirmentNotifications;
    NSInteger count = [self loadMore:&array];
    self.requirmentNotifications = array;
    
    return count;
}

- (NSInteger)refreshWorksiteNotifications {
    NSMutableArray *array = nil;
    NSInteger count = [self refresh:&array];
    self.worksiteNotifications = array;
    
    return count;
}

- (NSInteger)loadMoreWorksiteNotifications {
    NSMutableArray *array = self.worksiteNotifications;
    NSInteger count = [self loadMore:&array];
    self.worksiteNotifications = array;
    
    return count;
}

- (NSInteger)refresh:(NSMutableArray **)array {
    NSArray* arr = [[DataManager shared].data objectForKey:@"list"];
    NSMutableArray *notifications = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        UserNotification *notification = [[UserNotification alloc] initWith:dict];
        [notifications addObject:notification];
    }
    
    *array = notifications;
    return notifications.count;
}

- (NSInteger)loadMore:(NSMutableArray **)array {
    NSArray* arr = [[DataManager shared].data objectForKey:@"list"];
    NSMutableArray *notifications = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        UserNotification *notification = [[UserNotification alloc] initWith:dict];
        [notifications addObject:notification];
    }

    [*array addObjectsFromArray:notifications];
    return notifications.count;
}

@end
