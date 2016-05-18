//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "QuickLinkCell.h"

@interface QuickLinkCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@end

@implementation QuickLinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)updateUnreadNumber {
    //    [[NotificationDataManager shared] subscribeMyNotificationUnreadCount:^(NSInteger count) {
    //        self.btnMyNotification.shouldHideBadgeAtZero = YES;
    //        self.btnMyNotification.badgeNumber = [@(count) stringValue];
    //    }];
    //
    //    [[NotificationDataManager shared] subscribeMyLeaveMsgUnreadCount:^(NSInteger count) {
    //        self.btnMyLeaveMsg.shouldHideBadgeAtZero = YES;
    //        self.btnMyLeaveMsg.badgeNumber = [@(count) stringValue];
    //    }];
}

//- (IBAction)onClickComment:(id)sender {
//    [ViewControllerContainer showMyComments];
//}

@end
