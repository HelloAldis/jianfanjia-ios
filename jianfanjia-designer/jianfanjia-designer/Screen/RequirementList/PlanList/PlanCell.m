//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanCell.h"
#import "ViewControllerContainer.h"

static const NSInteger imgWidth = 170;
static const NSInteger imgSpace = 2;

@interface PlanCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblPlanTitleVal;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanTimeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanStatusVal;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnPlanPreview;
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;

@property (strong, nonatomic) Plan *plan;
@property (strong, nonatomic) Requirement *requirement;

@end

@implementation PlanCell

- (void)awakeFromNib {
    @weakify(self);
    [[self.btnComment rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickCommentButton];
    }];
    
    [[self.btnPlanPreview rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickPlanPreviewButton];
    }];
    
    [self.imgScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPlanPreviewButton)]];
}

- (void)initWithPlan:(Plan *)plan forRequirement:(Requirement *)requirement  {
    self.plan = plan;
    self.requirement = requirement;
    self.lblPlanTitleVal.text = [NSString stringWithFormat:@"%@ %@", requirement.basic_address, self.plan.name];
    self.lblPlanTimeVal.text = [NSDate yyyy_MM_dd:plan.last_status_update_time];
    
    [StatusBlock matchPlan:plan.status actions:
     @[[PlanWasChoosed action:^{
            self.lblPlanStatusVal.text = [NameDict nameForPlanStatus:plan.status];
            self.lblPlanStatusVal.textColor = kFinishedColor;
        }],
        [PlanWasNotChoosed action:^{
            self.lblPlanStatusVal.text = [NameDict nameForPlanStatus:plan.status];
            self.lblPlanStatusVal.textColor = kTextColor;
        }],
        [ElseStatus action:^{
            self.lblPlanStatusVal.text = @"沟通中";
            self.lblPlanStatusVal.textColor = kExcutionStatusColor;
        }],
       ]];
    
    if (plan.comment_count.intValue > 0) {
        [self.btnComment setNormTitle:[NSString stringWithFormat:@"评论(%@)", plan.comment_count]];
    }
    
    [self.imgScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    @weakify(self);
    [plan.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.frame = CGRectMake(idx * (imgWidth + imgSpace), 0, imgWidth, self.imgScrollView.bounds.size.height);
        [imgView setImageWithId:obj withWidth:imgWidth];
        [self.imgScrollView addSubview:imgView];
        
        if (imgSpace > 0) {
            UIView *space = [[UIView alloc] init];
            space.frame = CGRectMake(idx * imgWidth, 0, imgSpace, self.imgScrollView.bounds.size.height);
            [self.imgScrollView addSubview:space];
        }
    }];
    
    self.imgScrollView.contentSize = CGSizeMake((imgWidth + imgSpace) * plan.images.count, self.imgScrollView.bounds.size.height);
}

- (void)onClickCommentButton {
    [ViewControllerContainer leaveMessage:self.plan];
}

- (void)onClickPlanPreviewButton {
    [ViewControllerContainer showPlanPerview:self.plan forRequirement:self.requirement popTo:nil refresh:nil];
}

@end
