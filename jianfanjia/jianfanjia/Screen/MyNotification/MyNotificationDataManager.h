//
//  ReminderDataManager.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNotificationDataManager : NSObject

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
