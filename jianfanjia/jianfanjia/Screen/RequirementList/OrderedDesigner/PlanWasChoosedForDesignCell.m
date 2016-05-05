//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanWasChoosedForDesignCell.h"
#import "ViewControllerContainer.h"

@interface PlanWasChoosedForDesignCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnViewEvaluate;
@property (weak, nonatomic) IBOutlet UIButton *btnViewPlan;

@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;
@property (weak, nonatomic) IBOutlet UIImageView *vImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;

@end

@implementation PlanWasChoosedForDesignCell

- (void)awakeFromNib {
    [self.tagView setCornerRadius:self.tagView.bounds.size.height / 2];
    [self.imgAvatar setCornerRadius:30];
    [self.imgAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDesignerAvatar)]];
    
    @weakify(self);
    [[self.btnViewEvaluate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickEvaluateButton];
    }];
    
    [[self.btnViewPlan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickViewPlanButton];
    }];
}

- (void)initWithDesigner:(Designer *)designer withRequirement:(Requirement *)requirement withBlock:(PlanStatusRefreshBlock)refreshBlock {
    [super initWithDesigner:designer withRequirement:requirement withBlock:refreshBlock];
    [self initHeader:self.imgAvatar name:self.lblUserNameVal tagView:self.tagView lblTag:self.lblTag infoCheck:self.vImage stars:self.evaluatedStars];
    [self.btnViewEvaluate setNormTitle:designer.evaluation._id ? @"查看评价" : @"评价设计师"];
    
    self.lblStatus.text = [PlanWasChoosed text:self.requirement.status workType:self.requirement.work_type];
    self.lblStatus.textColor = [PlanWasChoosed textColor:self.requirement.status workType:self.requirement.work_type];
}

- (void)onClickEvaluateButton {
    [ViewControllerContainer showEvaluateDesigner:self.designer withRequirement:self.requirement._id];
}

- (void)onClickViewPlanButton {
    [ViewControllerContainer showPlanList:self.designer._id forRequirement:self.requirement];
}


@end
