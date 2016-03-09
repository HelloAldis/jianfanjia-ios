//
//  PostponeNotificationCell.h
//  jianfanjia
//
//  Created by Karos on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorksiteNotificationCell : UITableViewCell

- (void)initWithNotification:(UserNotification *)notification;
- (void)initWithSchedule:(Schedule *)schedule notification:(Notification *)notification refreshBlock:(void(^)(NSString *processid))Block;

@end
