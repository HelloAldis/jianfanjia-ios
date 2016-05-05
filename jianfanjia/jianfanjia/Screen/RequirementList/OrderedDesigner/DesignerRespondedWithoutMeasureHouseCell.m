//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerRespondedWithoutMeasureHouseCell.h"
#import "MessageAlertViewController.h"
#import "ViewControllerContainer.h"

@interface DesignerRespondedWithoutMeasureHouseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirmMeasureHouse;
@property (weak, nonatomic) IBOutlet UILabel *lblMeasureHouse;

@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;
@property (weak, nonatomic) IBOutlet UIImageView *vImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;

@end

@implementation DesignerRespondedWithoutMeasureHouseCell

- (void)awakeFromNib {
    [self.tagView setCornerRadius:self.tagView.bounds.size.height / 2];
    [self.imgAvatar setCornerRadius:30];
    [self.imgAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDesignerAvatar)]];
    
    @weakify(self);
    [[self.btnConfirmMeasureHouse rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickButton];
    }];
}

- (void)initWithDesigner:(Designer *)designer withRequirement:(Requirement *)requirement withBlock:(PlanStatusRefreshBlock)refreshBlock {
    [super initWithDesigner:designer withRequirement:requirement withBlock:refreshBlock];
    [self initHeader:self.imgAvatar name:self.lblUserNameVal tagView:self.tagView lblTag:self.lblTag infoCheck:self.vImage stars:self.evaluatedStars];
    self.lblStatus.text = [PlanDesignerResponded text:designer.plan.house_check_time];
    self.lblMeasureHouse.text = [NSString stringWithFormat:@"量房时间：%@", [NSDate yyyy_Nian_MM_Yue_dd_Ri_HH_mm:designer.plan.house_check_time]];
}

- (void)onClickButton {
    if ([PlanDesignerResponded isNowMoreThanCheckTime:self.designer.plan.house_check_time]) {
        [self confirmMeasureHouse];
    } else {
        [MessageAlertViewController presentAlert:@"提示" msg:@"您的量房时间还未到，是否需要确认量房？" second:nil reject:nil agree:^{
            [self confirmMeasureHouse];
        }];
    }
}

- (void)confirmMeasureHouse {
    ConfirmMeasuringHouse *request = [[ConfirmMeasuringHouse alloc] init];
    request.designerid = self.designer._id;
    request.requirementid = self.requirement._id;
    
    @weakify(self);
    [API confirmMeasuringHouse:request success:^{
        @strongify(self);
        [ViewControllerContainer showEvaluateDesigner:self.designer withRequirement:self.requirement._id];
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
