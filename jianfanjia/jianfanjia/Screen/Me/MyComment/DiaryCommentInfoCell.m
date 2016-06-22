//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiaryCommentInfoCell.h"
#import "ViewControllerContainer.h"

@interface DiaryCommentInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentTime;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIButton *btnReply;
@property (weak, nonatomic) IBOutlet UIView *linkView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLeftCons;
@property (weak, nonatomic) IBOutlet UIImageView *diaryImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblDiarySetTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDiarySetInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblDiaryContent;

@property (strong, nonatomic) UserNotification *notification;

@end

@implementation DiaryCommentInfoCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:self.imgAvatar.bounds.size.width / 2];
    [self.btnReply setBorder:1 andColor:kThemeTextColor.CGColor];
    [self.btnReply setCornerRadius:5];
    [self.linkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDec)]];
}

- (void)initWithNotification:(UserNotification *)notification {
    self.notification = notification;
    [self.imgAvatar setImageWithId:[CommentBusiness imageIdByNoti:notification] withWidth:CGRectGetWidth(self.imgAvatar.bounds) / 2];
    self.lblName.text = [CommentBusiness userNameByNoti:notification];
    self.lblCommentTime.text = [notification.create_at humDateString];
    self.lblComment.text = notification.content;
    
    [self updateLinkView];
}

- (void)updateLinkView {
    Section *section = [self.notification.process sectionForName:self.notification.section];
    Item *item = [section itemForName:self.notification.item];
//
//    if (section && item) {
//        self.lblLinkStatus.text = [NameDict nameForSectionStatus:item.status];
//        if ([item.status isEqualToString:kSectionStatusOnGoing]) {
//            self.linkStatusImage.image = [UIImage imageNamed:@"item_status_1"];
//            self.linkStatusLine2.bgColor = kFinishedColor;
//            self.lblLinkStatus.textColor = kExcutionStatusColor;
//        } else if([item.status isEqualToString:kSectionStatusAlreadyFinished]) {
//            self.linkStatusImage.image = [UIImage imageNamed:@"item_status_2"];
//            self.linkStatusLine2.bgColor = kFinishedColor;
//            self.lblLinkStatus.textColor = kFinishedColor;
//        } else {
//            self.linkStatusImage.image = [UIImage imageNamed:@"item_status_0"];
//            self.linkStatusLine2.bgColor = kUntriggeredColor;
//            self.lblLinkStatus.textColor = kUntriggeredColor;
//        }
//    }
//    
//    self.lblLinkCell.text = self.notification.process.basic_address;
//    self.lblLinkItem.text = item.label;
}

#pragma mark - user action
- (IBAction)onClickReply:(id)sender {
    [ViewControllerContainer leaveMessage:self.notification.process section:self.notification.section item:self.notification.item block:nil];
}

#pragma mark - gesture
- (void)onTapDec {
    [ViewControllerContainer showProcess:self.notification.topicid];
}

@end
