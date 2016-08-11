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
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UIButton *btnEvaluate;

@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;
@property (weak, nonatomic) IBOutlet UIImageView *vImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;

@end

@implementation DesignerMeasureHouseWithoutPlanCell

- (void)awakeFromNib {
    [self.tagView setCornerRadius:self.tagView.bounds.size.height / 2];
    [self.imgAvatar setCornerRadius:30];
    [self.imgAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDesignerAvatar)]];
    
    @weakify(self);
    [[self.btnEvaluate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickEvaluateButton];
    }];
}

- (void)initWithDesigner:(Designer *)designer withRequirement:(Requirement *)requirement withBlock:(PlanStatusRefreshBlock)refreshBlock {
    [super initWithDesigner:designer withRequirement:requirement withBlock:refreshBlock];
    [self initHeader:self.imgAvatar name:self.lblUserNameVal tagView:self.tagView lblTag:self.lblTag infoCheck:self.vImage stars:self.evaluatedStars];
    [self.btnEvaluate setNormTitle:designer.evaluation._id ? @"查看评价" : @"评价设计师"];
}

- (void)onClickEvaluateButton {
    [ViewControllerContainer showEvaluateDesigner:self.designer withRequirement:self.requirement._id];
}

@end
