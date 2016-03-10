//
//  PostponeNotificationCell.m
//  jianfanjia
//
//  Created by Karos on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "WorksiteNotificationCell.h"

@interface WorksiteNotificationCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSection;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationTime;

@property (strong, nonatomic) UserNotification *notification;

@end

@implementation WorksiteNotificationCell

- (void)initWithNotification:(UserNotification *)notification {
    self.notification = notification;
    self.lblNotificationTitle.text = notification.title;
    self.lblTitle.text = notification.cell;
    self.lblContent.text = notification.content;
    self.lblSection.text = notification.section;
    self.lblNotificationTime.text = [notification.create_at humDateString];
    
    [NotificationBusiness markTextColor:self.lblNotificationTitle status:notification.status];
    [NotificationBusiness markTextColor:self.lblTitle status:notification.status];
    [NotificationBusiness markTextColor:self.lblSection status:notification.status];
    [NotificationBusiness markTextColor:self.lblContent status:notification.status];
    [NotificationBusiness markTextColor:self.lblNotificationTime status:notification.status];
}

@end
