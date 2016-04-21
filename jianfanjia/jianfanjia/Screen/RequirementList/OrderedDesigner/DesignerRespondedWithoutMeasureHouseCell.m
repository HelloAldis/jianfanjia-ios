//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerRespondedWithoutMeasureHouseCell.h"
#import "ViewControllerContainer.h"

@interface DesignerRespondedWithoutMeasureHouseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirmMeasureHouse;

@property (weak, nonatomic) IBOutlet UIImageView *imgIdCardChecked;
@property (weak, nonatomic) IBOutlet UIImageView *imgBaseInfoChecked;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;

@end

@implementation DesignerRespondedWithoutMeasureHouseCell

- (void)awakeFromNib {
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
    [self initHeader:self.imgAvatar name:self.lblUserNameVal idCheck:self.imgIdCardChecked infoCheck:self.imgBaseInfoChecked stars:self.evaluatedStars];
    
    if ([[NSDate date] timeIntervalSince1970] > designer.plan.house_check_time.longLongValue / 1000) {
        self.btnConfirmMeasureHouse.enabled = YES;
        [self.btnConfirmMeasureHouse setNormTitle:@"确认量房"];
        [self.btnConfirmMeasureHouse setNormTitleColor:kThemeColor];
        [self.btnConfirmMeasureHouse setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightBold]];
    } else {
        self.btnConfirmMeasureHouse.enabled = NO;
        [self.btnConfirmMeasureHouse setNormTitle:[NSString stringWithFormat:@"量房时间：%@", [NSDate yyyy_MM_dd_HH_mm:designer.plan.house_check_time]]];
        [self.btnConfirmMeasureHouse setNormTitleColor:kUntriggeredColor];
        [self.btnConfirmMeasureHouse setFont:[UIFont systemFontOfSize:14]];
    }
    
    self.lblStatus.text = [PlanDesignerResponded text:designer.plan.house_check_time];
}

- (void)onClickButton {
    ConfirmMeasuringHouse *request = [[ConfirmMeasuringHouse alloc] init];
    request.designerid = self.designer._id;
    request.requirementid = self.requirement._id;
    
    @weakify(self);
    [API confirmMeasuringHouse:request success:^{
        @strongify(self);
//        [self refresh];
        [ViewControllerContainer showEvaluateDesigner:self.designer withRequirement:self.requirement._id];
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
