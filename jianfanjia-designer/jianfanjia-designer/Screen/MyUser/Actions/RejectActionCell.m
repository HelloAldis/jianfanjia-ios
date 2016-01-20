//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RejectActionCell.h"
#import "ViewControllerContainer.h"
#import "RequirementDataManager.h"

@interface RejectActionCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserGender;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblCellNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblRequirementfInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTimeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnEditRequirement;
@property (weak, nonatomic) IBOutlet UILabel *lblRejectReason;

@end

@implementation RejectActionCell

- (void)awakeFromNib {
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderView:)]];
    [self.imgHomeOwner setCornerRadius:self.imgHomeOwner.bounds.size.width / 2];
}

- (void)initWithRequirement:(Requirement *)requirement actionBlock:(ActionBlock)actionBlock {
    [super initWithRequirement:requirement actionBlock:actionBlock];
    [self initHeaderData:self.imgHomeOwner gender:self.imgUserGender name:self.lblUserName cell:self.lblCellNameVal info:self.lblRequirementfInfo updateTime:self.lblUpdateTimeVal];
    self.lblRejectReason.text = [NSString stringWithFormat:@"拒绝原因：%@", requirement.plan.reject_respond_msg ? requirement.plan.reject_respond_msg : @"其他"]; 
}

@end
