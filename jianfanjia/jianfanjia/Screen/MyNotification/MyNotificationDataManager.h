//
//  ReminderDataManager.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSArray *AllNotificationsFilter;
extern NSArray *SystemAnnouncementFilter;
extern NSArray *RequirmentNotificationFilter;
extern NSArray *WorksiteNotificationFilter;

@interface MyNotificationDataManager : NSObject

//@property (strong, nonatomic) NSMutableArray *schedules;
//@property (strong, nonatomic) NSArray *notifications;

//- (void)refreshSchedule:(NSString *)processid;
//- (void)refreshNotificationWithProcess:(NSString *)processid type:(NSString *)type;
//- (void)refreshNotificationWithProcess:(NSString *)processid type:(NSString *)type status:(NSString *)status;
//
//

@property (strong, nonatomic) NSMutableArray *allNotifications;
@property (strong, nonatomic) NSMutableArray *systemAnnouncements;
@property (strong, nonatomic) NSMutableArray *requirmentNotifications;
@property (strong, nonatomic) NSMutableArray *worksiteNotifications;

- (NSInteger)refreshAllNotifications;
- (NSInteger)loadMoreAllNotifications;

- (NSInteger)refreshSystemAnnouncements;
- (NSInteger)loadMoreSystemAnnouncements;

- (NSInteger)refreshRequirmentNotifications;
- (NSInteger)loadMoreRequirmentNotifications;

- (NSInteger)refreshWorksiteNotifications;
- (NSInteger)loadMoreWorksiteNotifications;

@end
