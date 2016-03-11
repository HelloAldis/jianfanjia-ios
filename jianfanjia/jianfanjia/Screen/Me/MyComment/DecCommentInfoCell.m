//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecCommentInfoCell.h"
#import "ViewControllerContainer.h"

@interface DecCommentInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentTime;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIButton *btnReply;
@property (weak, nonatomic) IBOutlet UIView *linkView;
@property (weak, nonatomic) IBOutlet UIView *linkStatusLine1;
@property (weak, nonatomic) IBOutlet UIView *linkStatusLine2;
@property (weak, nonatomic) IBOutlet UIImageView *linkStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkItemName;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkStatus;

@property (strong, nonatomic) UserNotification *notification;

@end

@implementation DecCommentInfoCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:self.imgAvatar.bounds.size.width / 2];
    [self.btnReply setBorder:1 andColor:kThemeTextColor.CGColor];
    [self.btnReply setCornerRadius:5];
    [self.linkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDec)]];
}

- (void)initWithNotification:(UserNotification *)notification {
    self.notification = notification;
    [self.imgAvatar setImageWithId:notification.designer.imageid withWidth:CGRectGetWidth(self.imgAvatar.bounds) / 2];
    self.lblName.text = notification.designer.username;
    self.lblCommentTime.text = [notification.create_at humDateString];
    self.lblComment.text = notification.content;
    
    [self updateLinkView];
}

- (void)updateLinkView {
    self.lblLinkItemName.text = [NSString stringWithFormat:@"%@ %@", self.notification.process.cell, [ProcessBusiness nameForKey:self.notification.item]];

    Section *section = nil;
    Item *item = nil;
    
    NSPredicate *sectionPre = [NSPredicate predicateWithFormat:@"SELF.name == %@", self.notification.section];
    NSArray *sections = [self.notification.process.sections filteredArrayUsingPredicate:sectionPre];
    if (sections.count > 0) {
        section = [[Section alloc] initWith:sections[0]];
        
        NSPredicate *itemPre = [NSPredicate predicateWithFormat:@"SELF.name == %@", self.notification.item];
        NSArray *items = [[section.data valueForKey:@"items"] filteredArrayUsingPredicate:itemPre];
        if (items) {
            item = [[Item alloc] initWith:items[0]];
        }
    }

    if (section && item) {
        self.lblLinkStatus.text = [NameDict nameForSectionStatus:item.status];
        if ([item.status isEqualToString:kSectionStatusOnGoing]
            || [item.status isEqualToString:kSectionStatusChangeDateRequest]
            || [item.status isEqualToString:kSectionStatusChangeDateAgree]
            || [item.status isEqualToString:kSectionStatusChangeDateDecline]) {
            self.linkStatusImage.image = [UIImage imageNamed:@"item_status_1"];
            self.linkStatusLine2.backgroundColor = kFinishedColor;
        } else if([item.status isEqualToString:kSectionStatusAlreadyFinished]) {
            self.linkStatusImage.image = [UIImage imageNamed:@"item_status_2"];
            self.linkStatusLine2.backgroundColor = kFinishedColor;
        } else {
            self.linkStatusImage.image = [UIImage imageNamed:@"item_status_0"];
            self.linkStatusLine2.backgroundColor = kUntriggeredColor;
        }
    }
}

#pragma mark - user action
- (IBAction)onClickReply:(id)sender {
    [ViewControllerContainer leaveMessage:self.notification.topicid designer:self.notification.designerid section:self.notification.section item:self.notification.item block:nil];
}

#pragma mark - gesture
- (void)onTapDec {
    [ViewControllerContainer showProcess:self.notification.topicid];
}

@end
