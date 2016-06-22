//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiaryCommentInfoCell.h"
#import "DiaryMessageCell.h"
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
@property (weak, nonatomic) IBOutlet UILabel *lblDiaryContent;

@property (strong, nonatomic) UserNotification *notification;

@end

@implementation DiaryCommentInfoCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:self.imgAvatar.bounds.size.width / 2];
    [self.btnReply setBorder:1 andColor:kThemeTextColor.CGColor];
    [self.btnReply setCornerRadius:5];
    [self.linkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDiary)]];
}

- (void)initWithNotification:(UserNotification *)notification {
    self.notification = notification;
    [self.imgAvatar setImageWithId:[CommentBusiness imageIdByNoti:notification] withWidth:CGRectGetWidth(self.imgAvatar.bounds) / 2];
    self.lblName.text = [CommentBusiness userNameByNoti:notification];
    self.lblCommentTime.text = [notification.create_at humDateString];
    
    NSRange prefixRange = [notification.content rangeOfString:kDiaryMessagePrefix];
    NSRange subfixRange = [notification.content rangeOfString:kDiaryMessageSubfix];
    
    if (prefixRange.location != NSNotFound && subfixRange.location != NSNotFound) {
        NSRange hilightRange = NSMakeRange(prefixRange.location + prefixRange.length, subfixRange.location - prefixRange.location - prefixRange.length);
        NSString *hilightString = [notification.content substringWithRange:hilightRange];
        
        self.lblComment.attributedText = [notification.content attrSubStr:hilightString font:self.lblComment.font color:kThemeColor];
    } else {
        self.lblComment.text = notification.content;
    }
    
    [self updateLinkView];
}

- (void)updateLinkView {
    if (self.notification.diary.images.count > 0) {
        LeafImage *img = [[LeafImage alloc] initWith:self.notification.diary.images[0]];
        [self.diaryImgView setImageWithId:img.imageid withWidth:self.diaryImgView.frame.size.width];
        self.imgLeftCons.constant = 14.0;
    } else {
        self.imgLeftCons.constant = - CGRectGetWidth(self.diaryImgView.frame);
    }
    
    self.lblDiarySetTitle.text = self.notification.diary.diarySet.title;
    self.lblDiaryContent.text = [NSString stringWithFormat:@"%@\n%@", [DiaryBusiness diarySetInfo:self.notification.diary.diarySet], self.notification.diary.content];;
    [self.lblDiaryContent setRowSpace:5];
}

#pragma mark - user action
- (IBAction)onClickReply:(id)sender {
    [ViewControllerContainer showDiaryDetail:self.notification.diary showComment:YES deletedBlock:nil];
}

#pragma mark - gesture
- (void)onTapDiary {
    [ViewControllerContainer showDiaryDetail:self.notification.diary showComment:NO deletedBlock:nil];
}

@end
