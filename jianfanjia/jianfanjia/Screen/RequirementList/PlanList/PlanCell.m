//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanCell.h"

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
}

- (void)initWithPlan:(Plan *)plan withOrder:(NSInteger)order forRequirement:(Requirement *)requirement  {
    self.plan = plan;
    self.requirement = requirement;
    self.lblPlanTitleVal.text = [NSString stringWithFormat:@"%@%@期 方案%ld", requirement.cell, requirement.cell_phase, order];
    self.lblPlanTimeVal.text = [NSDate yyyy_MM_dd:plan.last_status_update_time];
    
    if ([plan.status isEqualToString:kPlanStatusPlanWasChoosed] || [plan.status isEqualToString:kPlanStatusPlanWasNotChoosed]) {
        self.lblPlanStatusVal.text = [NameDict nameForPlanStatus:plan.status];
        
        if ([plan.status isEqualToString:kPlanStatusPlanWasChoosed]) {
            self.lblPlanStatusVal.textColor = [UIColor colorWithR:0xFE g:0x70 b:0x04];
        } else {
            self.lblPlanStatusVal.textColor = [UIColor colorWithR:0x7C g:0x83 b:0x89];
        }
    }
    
    if (plan.comment_count.intValue > 0) {
        self.btnComment.enabled = YES;
        self.btnComment.alpha = 1.0;
        [self.btnComment setTitle:[NSString stringWithFormat:@"留言(%@)", plan.comment_count] forState:UIControlStateNormal];
    } else {
        self.btnComment.enabled = NO;
        self.btnComment.alpha = 0.5;
    }
    
    @weakify(self);
    [plan.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(idx * (imgWidth + imgSpace), 0, imgWidth, self.imgScrollView.bounds.size.height);
        [imgView setImageWithId:obj withWidth:imgWidth];
        [self.imgScrollView addSubview:imgView];
        
        UIView *space = [[UIView alloc] init];
        space.frame = CGRectMake(idx * imgWidth, 0, imgSpace, self.imgScrollView.bounds.size.height);
        [self.imgScrollView addSubview:space];
    }];
    
    self.imgScrollView.contentSize = CGSizeMake((imgWidth + imgSpace) * plan.images.count, self.imgScrollView.bounds.size.height);
}

- (void)onClickCommentButton {
    
}

- (void)onClickPlanPreviewButton {
    
}

@end
