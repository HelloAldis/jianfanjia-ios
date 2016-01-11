//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerRespondedWithoutMeasureHouseCell.h"

@interface DesignerRespondedWithoutMeasureHouseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblMeasureHouseTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMeasureHouseTimeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirmMeasureHouse;

@end

@implementation DesignerRespondedWithoutMeasureHouseCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:30];
    [self.btnConfirmMeasureHouse setCornerRadius:5];
    
    @weakify(self);
    [[self.btnConfirmMeasureHouse rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickButton];
    }];
    
    [self.imgAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDesignerAvatar)]];
}

- (void)initWithDesigner:(Designer *)designer withRequirement:(Requirement *)requirement withBlock:(PlanStatusRefreshBlock)refreshBlock {
    [super initWithDesigner:designer withRequirement:requirement withBlock:refreshBlock];
    [self.imgAvatar setImageWithId:designer.imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = designer.username;
    [DesignerBusiness setV:self.authIcon withAuthType:designer.auth_type];
    self.lblMeasureHouseTimeVal.text = [NSDate yyyy_MM_dd_HH_mm:designer.plan.house_check_time];
    if ([[NSDate date] timeIntervalSince1970] > designer.plan.house_check_time.longLongValue / 1000) {
        self.btnConfirmMeasureHouse.hidden = NO;
        self.lblMeasureHouseTime.hidden = YES;
        self.lblMeasureHouseTimeVal.hidden = YES;
    } else {
        self.btnConfirmMeasureHouse.hidden = YES;
        self.lblMeasureHouseTime.hidden = NO;
        self.lblMeasureHouseTimeVal.hidden = NO;
    }
}

- (void)onClickButton {
    ConfirmMeasuringHouse *request = [[ConfirmMeasuringHouse alloc] init];
    request.designerid = self.designer._id;
    request.requirementid = self.requirement._id;
    
    @weakify(self);
    [API confirmMeasuringHouse:request success:^{
        @strongify(self);
        [self refresh];
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
