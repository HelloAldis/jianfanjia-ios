//
//  PurchaseNotificationCell.m
//  jianfanjia
//
//  Created by Karos on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementNotificationCell.h"

@interface RequirementNotificationCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestTime;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkingPhase;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIView *reminderIcon;

@property (strong, nonatomic) Notification *notification;

@end

@implementation RequirementNotificationCell

- (void)awakeFromNib {
    [self.reminderIcon setCornerRadius:self.reminderIcon.bounds.size.width / 2];
}

- (void)initWithNotification:(Notification *)notification {
    self.notification = notification;
    self.lblCell.text = self.notification.cell;
    self.lblContent.text = self.notification.content;
    self.lblRequestTime.text = [NSDate yyyy_MM_dd_HH_mm:self.notification.time];
    self.lblWorkingPhase.text = [NSString stringWithFormat:@"%@阶段", [ProcessBusiness nameForKey:self.notification.section]];
    if ([self.notification.status isEqualToString:kNotificationStatusUnread]) {
        self.reminderIcon.alpha = 1.0;
    } else {
        self.reminderIcon.alpha = 0;
    }
}

@end
