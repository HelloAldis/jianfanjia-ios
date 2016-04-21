//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RespondedActionCell.h"
#import "ViewControllerContainer.h"

@interface RespondedActionCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserGender;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblCellNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblRequirementfInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTimeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnEditRequirement;

@property (weak, nonatomic) IBOutlet UILabel *lblMeasureHouseTime;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;
@property (weak, nonatomic) IBOutlet UIButton *btnNotifyUserToConfirmMeasureHouse;
@property (weak, nonatomic) IBOutlet UILabel *lblNotifyUserToConfirmMeasureHouse;
@property (weak, nonatomic) IBOutlet UIImageView *iconBell;

@end

@implementation RespondedActionCell

- (void)awakeFromNib {
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderView:)]];
    [self.imgHomeOwner setCornerRadius:self.imgHomeOwner.bounds.size.width / 2];
    
    @weakify(self);
    [[self.btnContact rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickContact];
    }];
    
    [[self.btnNotifyUserToConfirmMeasureHouse rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickNotifyUserToConfirmMeasureHouse];
    }];
}

- (void)initWithRequirement:(Requirement *)requirement actionBlock:(ActionBlock)actionBlock {
    [super initWithRequirement:requirement actionBlock:actionBlock];
    [self initHeaderData:self.imgHomeOwner gender:self.imgUserGender name:self.lblUserName cell:self.lblCellNameVal info:self.lblRequirementfInfo updateTime:self.lblUpdateTimeVal];
    self.lblStatus.text = [PlanDesignerResponded text:self.requirement.plan.house_check_time];
    
    if ([PlanDesignerResponded isNowMoreThanCheckTime:self.requirement.plan.house_check_time]) {
        [self displayMeasureTime:NO];
    } else {
        [self displayMeasureTime:YES];
        self.lblMeasureHouseTime.text = [NSString stringWithFormat:@"量房时间：%@", [NSDate yyyy_Nian_MM_Yue_dd_Ri_HH_mm:self.requirement.plan.house_check_time]];
    }
}

- (void)displayMeasureTime:(BOOL)display {
    self.lblMeasureHouseTime.hidden = !display;
    self.btnNotifyUserToConfirmMeasureHouse.hidden = display;
    self.lblNotifyUserToConfirmMeasureHouse.hidden = display;
    self.iconBell.hidden = display;
}

#pragma mark - user action
- (void)onClickNotifyUserToConfirmMeasureHouse {
    DesignerNotifyUserToConfirmMeasureHouse *request = [[DesignerNotifyUserToConfirmMeasureHouse alloc] init];
    request.planid = self.requirement.plan._id;
    request.userid = self.requirement.user._id;
    
    [API designerNotifyUserToConfirmMeasureHouse:request success:^{
    } failure:^{
    } networkError:^{
    }];
}

@end
