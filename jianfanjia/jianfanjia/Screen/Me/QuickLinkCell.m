//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "QuickLinkCell.h"
#import "ViewControllerContainer.h"
#import "MyFavoriateViewController.h"

@interface QuickLinkCell ()
@property (weak, nonatomic) IBOutlet UIView *myProductView;
@property (weak, nonatomic) IBOutlet UIView *myTeamView;
@property (weak, nonatomic) IBOutlet UIView *myMessageView;
@property (weak, nonatomic) IBOutlet UIButton *btnMyLeaveMsg;

@end

@implementation QuickLinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.myProductView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMyDiarySet)]];
    [self.myTeamView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickFavoriate)]];
    [self.myMessageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMyMessage)]];
    
    [[NotificationDataManager shared] subscribeMyLeaveMsgUnreadCount:^(NSInteger count) {
        self.btnMyLeaveMsg.shouldHideBadgeAtZero = YES;
        self.btnMyLeaveMsg.badgeNumber = [@(count) stringValue];
    }];
}

- (void)onTapMyDiarySet {
//    [ViewControllerContainer showMyComments];
}

- (void)onClickFavoriate {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            MyFavoriateViewController *v = [[MyFavoriateViewController alloc] initWithNibName:nil bundle:nil];
            [[ViewControllerContainer navigation] pushViewController:v animated:YES];
        }
    }];
}

- (void)onTapMyMessage {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            [ViewControllerContainer showMyComments];
        }
    }];
}

@end
