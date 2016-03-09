//
//  ReminderDataManager.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSArray *SystemAnnouncementFilter = nil;
static NSArray *RequirmentNotificationFilter = nil;
static NSArray *WorksiteNotificationFilter = nil;

@interface MyNotificationDataManager : NSObject

//@property (strong, nonatomic) NSMutableArray *schedules;
//@property (strong, nonatomic) NSArray *notifications;

//- (void)refreshSchedule:(NSString *)processid;
//- (void)refreshNotificationWithProcess:(NSString *)processid type:(NSString *)type;
//- (void)refreshNotificationWithProcess:(NSString *)processid type:(NSString *)type status:(NSString *)status;
//
//

@property (strong, nonatomic) NSMutableArray *allNotification;
@property (strong, nonatomic) NSMutableArray *systemAnnouncements;
@property (strong, nonatomic) NSMutableArray *requirmentNotifications;
@property (strong, nonatomic) NSMutableArray *worksiteNotifications;

- (void)refreshAllNotifications;
- (void)loadMoreAllNotifications;

- (void)refreshSystemAnnouncements;
- (void)loadMoreSystemAnnouncements;

- (void)refreshRequirmentNotifications;
- (void)loadMoreRequirmentNotifications;

- (void)refreshWorksiteNotifications;
- (void)loadMoreWorksiteNotifications;

@end
