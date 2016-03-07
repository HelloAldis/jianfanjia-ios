//
//  PostponeNotificationCell.m
//  jianfanjia
//
//  Created by Karos on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RescheduleNotificationCell.h"

@interface RescheduleNotificationCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkingPhase;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestTime;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIView *reminderIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;

@property (strong, nonatomic) Schedule *schedule;
@property (copy, nonatomic) void (^RefreshBlock)(NSString *processid);

@end

@implementation RescheduleNotificationCell

- (void)awakeFromNib {
    [self.reminderIcon setCornerRadius:self.reminderIcon.bounds.size.width / 2];
    [self.btnAgree setCornerRadius:5];
    [self.btnReject setBorder:1 andColor:kFinishedColor.CGColor];
    [self.btnReject setCornerRadius:5];
    
    @weakify(self);
    [[self.btnAgree rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self agreeChangeDate];
    }];
    
    [[self.btnReject rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self rejectChangeDate];
    }];
}

- (void)initWithSchedule:(Schedule *)schedule notification:(Notification *)notification refreshBlock:(void(^)(NSString *processid))Block {
    self.RefreshBlock = Block;
    self.schedule = schedule;
    self.lblCell.text = schedule.process.cell;
    self.lblWorkingPhase.text = [NSString stringWithFormat:@"%@阶段", [ProcessBusiness nameForKey:schedule.section]];
    self.lblRequestTime.text = [NSDate yyyy_MM_dd_HH_mm:schedule.request_date];
    self.lblStatus.text = [NameDict nameForSectionStatus:schedule.status];
    
    if ([schedule.status isEqualToString:kSectionStatusChangeDateAgree]) {
        self.lblStatus.textColor = kPassStatusColor;
    } else if ([schedule.status isEqualToString:kSectionStatusChangeDateDecline]) {
        self.lblStatus.textColor = kReminderColor;
    }
    
    if (![[GVUserDefaults standardUserDefaults].usertype isEqualToString:schedule.request_role]
        && [schedule.status isEqualToString:kSectionStatusChangeDateRequest]) {
//        self.lblStatus.text = @"未处理，请及时处理";
        [self hideButtons:NO];
    } else {
        [self hideButtons:YES];
    }
    
    if (![[GVUserDefaults standardUserDefaults].usertype isEqualToString:schedule.request_role]) {
        self.lblContent.text = [NSString stringWithFormat:@"对方已申请改期验收至%@", [NSDate yyyy_MM_dd:schedule.updated_date]];
    } else {
        self.lblContent.text = [NSString stringWithFormat:@"您已申请改期验收至%@", [NSDate yyyy_MM_dd:schedule.updated_date]];
    }
    
    if ([notification.status isEqualToString:kNotificationStatusUnread]) {
        self.reminderIcon.alpha = 1.0;
    } else {
        self.reminderIcon.alpha = 0;
    }
}

- (void)hideButtons:(BOOL)hide {
    self.btnAgree.hidden = hide;
    self.btnReject.hidden = hide;
    self.lblStatus.hidden = !hide;
}

- (void)agreeChangeDate {
    AgreeReschedule *request = [[AgreeReschedule alloc] init];
    request.processid = self.schedule.process._id;
    
    [API agreeReschedule:request success:^{
        if (self.RefreshBlock) {
            self.RefreshBlock(self.schedule.processid);
        }
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)rejectChangeDate {
    RejectReschedule *request = [[RejectReschedule alloc] init];
    request.processid = self.schedule.process._id;
    
    [API rejectReschedule:request success:^{
        if (self.RefreshBlock) {
            self.RefreshBlock(self.schedule.processid);
        }
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
