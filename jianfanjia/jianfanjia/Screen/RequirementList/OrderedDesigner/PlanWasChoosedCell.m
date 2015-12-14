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
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UIButton *btnViewPlan;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAgreement;

@end

@implementation PlanWasChoosedCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:30];
    [self.btnViewAgreement setCornerRadius:5];
    [self.btnViewPlan setBorder:1 andColor:kFinishedColor.CGColor];
    [self.btnViewPlan setCornerRadius:5];
    
    @weakify(self);
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
    [self.imgAvatar setImageWithId:designer.imageid withWidth:self.imgAvatar.bounds.size.width];
//    self.lblUserNameVal.text = designer.username;
    [DesignerBusiness setV:self.authIcon withAuthType:designer.auth_type];
}

- (void)onClickViewPlanButton {
    [ViewControllerContainer showPlanList:self.designer._id forRequirement:self.requirement];
}

- (void)onClickViewAgreementButton {
    [ViewControllerContainer showAgreement:self.requirement];
}

@end
