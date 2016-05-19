//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "QuickLinkCell.h"
#import "ViewControllerContainer.h"

@interface QuickLinkCell ()
@property (weak, nonatomic) IBOutlet UIView *myProductView;
@property (weak, nonatomic) IBOutlet UIView *myTeamView;
@property (weak, nonatomic) IBOutlet UIView *myMessageView;
@property (weak, nonatomic) IBOutlet UIButton *btnMyLeaveMsg;

@end

@implementation QuickLinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.myProductView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMyProduct)]];
    [self.myTeamView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMyTeam)]];
    [self.myMessageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMyMessage)]];
    
    [[NotificationDataManager shared] subscribeMyLeaveMsgUnreadCount:^(NSInteger count) {
        self.btnMyLeaveMsg.shouldHideBadgeAtZero = YES;
        self.btnMyLeaveMsg.badgeNumber = [@(count) stringValue];
    }];
}

- (void)onTapMyProduct {
    [ViewControllerContainer showProductAuth];
}

- (void)onTapMyTeam {
    [ViewControllerContainer showTeamAuth];
}

- (void)onTapMyMessage {
    [ViewControllerContainer showMyComments];
}

@end
