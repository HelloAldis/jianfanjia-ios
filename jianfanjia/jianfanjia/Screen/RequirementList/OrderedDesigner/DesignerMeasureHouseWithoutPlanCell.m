//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerMeasureHouseWithoutPlanCell.h"
#import "ViewControllerContainer.h"

@interface DesignerMeasureHouseWithoutPlanCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UIButton *btnViewPlan;
@property (weak, nonatomic) IBOutlet UIButton *btnEvaluate;

@end

@implementation DesignerMeasureHouseWithoutPlanCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:30];
    [self.btnViewPlan setCornerRadius:5];
    [self.btnViewPlan setBorder:1 andColor:[UIColor colorWithR:0xb5 g:0xb9 b:0xbc].CGColor];
    [self.btnEvaluate setCornerRadius:5];
    [self.btnEvaluate setBorder:1 andColor:[UIColor colorWithR:0xFE g:0x70 b:0x04].CGColor];
    
    @weakify(self);
    [[self.btnEvaluate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
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
    [self.imgAvatar setImageWithId:designer.imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = designer.username;
    [DesignerBusiness setV:self.authIcon withAuthType:designer.auth_Type];
    
    if (self.designer.evaluation) {
        [self.btnEvaluate setTitle:@"已评价" forState:UIControlStateNormal];
    }
}

- (void)onClickEvaluateButton {
    [ViewControllerContainer showEvaluateDesigner:self.designer withRequirement:self.requirement._id];
}

- (void)onClickViewPlanButton {
    
}

@end
