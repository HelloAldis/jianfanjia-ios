//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UnrespondActionCell.h"
#import "ViewControllerContainer.h"
#import "RequirementDataManager.h"

@interface UnrespondActionCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserGender;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblCellNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblRequirementfInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTimeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnEditRequirement;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
@property (weak, nonatomic) IBOutlet UIButton *btnRespond;

@end

@implementation UnrespondActionCell

- (void)awakeFromNib {
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderView:)]];
    [self.imgHomeOwner setCornerRadius:self.imgHomeOwner.bounds.size.width / 2];
    
    @weakify(self);
    [[self.btnReject rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickReject];
    }];
    
    [[self.btnReject rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickRespond];
    }];
}

- (void)initWithRequirement:(Requirement *)requirement actionBlock:(ActionBlock)actionBlock {
    [super initWithRequirement:requirement actionBlock:actionBlock];
    [self initHeaderData:self.imgHomeOwner gender:self.imgUserGender name:self.lblUserName cell:self.lblCellNameVal info:self.lblRequirementfInfo updateTime:self.lblUpdateTimeVal];
}

#pragma mark - user action
- (void)onClickReject {
    
}

- (void)onClickRespond {
    
}

@end
