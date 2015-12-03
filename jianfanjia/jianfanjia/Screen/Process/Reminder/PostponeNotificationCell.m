//
//  PostponeNotificationCell.m
//  jianfanjia
//
//  Created by Karos on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PostponeNotificationCell.h"

@interface PostponeNotificationCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkingPhase;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestTime;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (strong, nonatomic) Schedule *schedule;

@end

@implementation PostponeNotificationCell

- (void)awakeFromNib {
    
}

- (void)initWithSchedule:(Schedule *)schedule {
    self.schedule = schedule;
    self.lblCell.text = schedule.process.cell;
    self.lblWorkingPhase.text = [NSString stringWithFormat:@"%@阶段", [ProcessBusiness nameForKey:schedule.section]];
    self.lblRequestTime.text = [NSDate yyyy_MM_dd_HH_mm:schedule.request_date];
    self.lblStatus.text = [NameDict nameForSectionStatus:schedule.status];
    
    if (![[GVUserDefaults standardUserDefaults].usertype isEqualToString:schedule.request_role]
        && [schedule.status isEqualToString:kSectionStatusChangeDateRequest]) {
        self.lblStatus.text = @"未处理，请及时处理";
    }
    
    if (![[GVUserDefaults standardUserDefaults].usertype isEqualToString:schedule.request_role]) {
        self.lblContent.text = [NSString stringWithFormat:@"对方已申请改期验收至%@", [NSDate yyyy_MM_dd:schedule.updated_date]];
    } else {
        self.lblContent.text = [NSString stringWithFormat:@"您已申请改期验收至%@", [NSDate yyyy_MM_dd:schedule.updated_date]];
    }
}

@end
