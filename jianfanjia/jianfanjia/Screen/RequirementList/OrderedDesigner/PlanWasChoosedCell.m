//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanWasChoosedCell.h"
#import "ViewControllerContainer.h"

@interface PlanWasChoosedCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UIButton *btnViewEvaluate;
@property (weak, nonatomic) IBOutlet UIButton *btnViewPlan;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAgreement;

@property (weak, nonatomic) IBOutlet UIImageView *imgIdCardChecked;
@property (weak, nonatomic) IBOutlet UIImageView *imgBaseInfoChecked;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;

@end

@implementation PlanWasChoosedCell

- (void)awakeFromNib {
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
    
    [[self.btnViewAgreement rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickViewAgreementButton];
    }];
}

- (void)initWithDesigner:(Designer *)designer withRequirement:(Requirement *)requirement withBlock:(PlanStatusRefreshBlock)refreshBlock {
    [super initWithDesigner:designer withRequirement:requirement withBlock:refreshBlock];
    [self initHeader:self.imgAvatar name:self.lblUserNameVal idCheck:self.imgIdCardChecked infoCheck:self.imgBaseInfoChecked stars:self.evaluatedStars];
    [self.btnViewEvaluate setTitle:designer.evaluation._id ? @"查看评价" : @"评价设计师" forState:UIControlStateNormal];
}

- (void)onClickEvaluateButton {
    [ViewControllerContainer showEvaluateDesigner:self.designer withRequirement:self.requirement._id];
}

- (void)onClickViewPlanButton {
    [ViewControllerContainer showPlanList:self.designer._id forRequirement:self.requirement];
}

- (void)onClickViewAgreementButton {
    [ViewControllerContainer showAgreement:self.requirement popTo:[ViewControllerContainer getCurrentTapController].navigationController.viewControllers.firstObject refresh:nil];
}

@end
