//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UnrespondActionCell.h"
#import "ViewControllerContainer.h"
#import "RejectUserAlertViewController.h"
#import "SetMeasureHouseTimeViewController.h"

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
    
    [[self.btnRespond rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
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
    [RejectUserAlertViewController presentAlert:@"拒绝接单原因" msg:@"PS：以下收集的信息，将不会向业主展示，麻烦您耐心填写拒绝接单原因，以便我们合作更加紧密。" conform:^(NSString *reason) {
        if (reason) {
            [HUDUtil showWait];
            DesignerRejectUser *request = [[DesignerRejectUser alloc] init];
            request.requirementid = self.requirement._id;
            request.reject_respond_msg = reason;
            [API designerRejectUser:request success:^{
                [HUDUtil hideWait];
                if (self.actionBlock) {
                    self.actionBlock();
                }
            } failure:^{
                [HUDUtil hideWait];
            } networkError:^{
                [HUDUtil hideWait];
            }];
        }
    }];
}

- (void)onClickRespond {
    DesignerRespondUser *request = [[DesignerRespondUser alloc] init];
    request.requirementid = self.requirement._id;
    [API designerRespondUser:request success:nil failure:nil networkError:nil];
    
    [SetMeasureHouseTimeViewController showSetMeasureHouseTime:self.requirement completion:^(BOOL completion) {
        if (completion) {
            if (self.actionBlock) {
                self.actionBlock();
            }
        }
    }];
}

@end
