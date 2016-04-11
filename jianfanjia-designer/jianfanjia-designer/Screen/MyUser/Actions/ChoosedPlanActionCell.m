//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ChoosedPlanActionCell.h"
#import "ViewControllerContainer.h"
#import "SetWorksiteStartTimeViewController.h"

@interface ChoosedPlanActionCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserGender;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblCellNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblRequirementfInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTimeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnEditRequirement;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAgreement;
@property (weak, nonatomic) IBOutlet UILabel *lblViewAgreement;
@property (weak, nonatomic) IBOutlet UIImageView *iconViewAgreement;
@property (weak, nonatomic) IBOutlet UIButton *btnViewPlan;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;

@end

@implementation ChoosedPlanActionCell

- (void)awakeFromNib {
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderView:)]];
    [self.imgHomeOwner setCornerRadius:self.imgHomeOwner.bounds.size.width / 2];
    
    @weakify(self);
    [[self.btnViewAgreement rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickViewAgreement];
    }];
    
    [[self.btnViewPlan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickViewPlan];
    }];
    
    [[self.btnContact rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickContact];
    }];
}

- (void)initWithRequirement:(Requirement *)requirement actionBlock:(ActionBlock)actionBlock {
    [super initWithRequirement:requirement actionBlock:actionBlock];
    [self initHeaderData:self.imgHomeOwner gender:self.imgUserGender name:self.lblUserName cell:self.lblCellNameVal info:self.lblRequirementfInfo updateTime:self.lblUpdateTimeVal];
    
    if (self.requirement.start_at) {
        self.lblViewAgreement.text = @"查看合同";
        self.iconViewAgreement.image = [UIImage imageNamed:@"icon_view_agreement"];
    } else {
        self.lblViewAgreement.text = @"设置开工时间";
        self.iconViewAgreement.image = [UIImage imageNamed:@"icon_set_work_time"];
    }
    
    NSString *status = self.requirement.status;
    self.lblStatus.text = [PlanWasChoosed text:status];
    self.lblStatus.textColor = [PlanWasChoosed textColor:status];
}

#pragma mark - user action
- (void)onClickViewAgreement {
    [SetWorksiteStartTimeViewController showSetMeasureHouseTime:self.requirement completion:^(BOOL completion) {
        if (completion) {
            if (self.actionBlock) {
                self.actionBlock();
            }
        }
    }];
}

@end
