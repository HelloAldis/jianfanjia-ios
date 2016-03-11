//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanCommentInfoCell.h"
#import "ViewControllerContainer.h"

static const NSInteger imgWidth = 140;
static const NSInteger imgSpace = 2;

@interface PlanCommentInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentTime;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIButton *btnReply;
@property (weak, nonatomic) IBOutlet UIView *linkView;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkStatus;
@property (weak, nonatomic) IBOutlet UIScrollView *linkImageScrollView;

@property (strong, nonatomic) UserNotification *notification;

@end

@implementation PlanCommentInfoCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:self.imgAvatar.bounds.size.width / 2];
    [self.btnReply setBorder:1 andColor:kThemeTextColor.CGColor];
    [self.btnReply setCornerRadius:5];
    [self.linkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPlan)]];
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
    self.lblLinkTitle.text = self.notification.requirement.cell;
    self.lblLinkStatus.text = [NameDict nameForPlanStatus:self.notification.plan.status];
    
    [self.linkImageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat scrollViewHeight = self.linkImageScrollView.bounds.size.height;
    @weakify(self);
    [self.notification.plan.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.frame = CGRectMake(idx * (imgWidth + imgSpace), 0, imgWidth, scrollViewHeight);
        [imgView setImageWithId:obj withWidth:imgWidth];
        [self.linkImageScrollView addSubview:imgView];
        
        if (imgSpace > 0) {
            UIView *space = [[UIView alloc] init];
            space.frame = CGRectMake(idx * imgWidth, 0, imgSpace, scrollViewHeight);
            [self.linkImageScrollView addSubview:space];
        }
    }];
    
    self.linkImageScrollView.contentSize = CGSizeMake((imgWidth + imgSpace) * self.notification.plan.images.count, scrollViewHeight);
}

#pragma mark - user action
- (IBAction)onClickReply:(id)sender {
    self.notification.plan.designerid = self.notification.designerid;
    [ViewControllerContainer leaveMessage:self.notification.plan];
}

#pragma mark - gesture
- (void)onTapPlan {
    [ViewControllerContainer showPlanPerview:self.notification.plan withOrder:0 forRequirement:self.notification.requirement];
}

@end
