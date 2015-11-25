//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementCell.h"
#import "ViewControllerContainer.h"
#import "RequirementDataManager.h"

@interface RequirementCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblCellNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblPubulishTimeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTimeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnEditRequirement;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *designerAvatar;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *authIcon;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *designerName;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *designerStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblRequirementStatusVal;
@property (weak, nonatomic) IBOutlet UIButton *btnGoToWorkspace;

@property (strong, nonatomic) NSMutableArray *currentPlanStatus;
@property (strong, nonatomic) NSString *currentRequirementStatus;
@property (strong, nonatomic) RequirementDataManager *requirementDataManager;
@property (strong, nonatomic) Requirement *requirement;

@end

@implementation RequirementCell

- (void)awakeFromNib {
    self.requirementDataManager = [[RequirementDataManager alloc] init];
    self.currentPlanStatus = [[NSMutableArray alloc] initWithCapacity:self.designerAvatar.count];
    
    @weakify(self);
    [self.designerStatus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self.currentPlanStatus addObject:kPlanStatusUnorder];
    }];
    
    [self.designerAvatar enumerateObjectsUsingBlock:^(UIImageView* _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDesignerAvatar:)];
        [imageView setCornerRadius:30];
        [imageView addGestureRecognizer:gesture];
    }];
    
    [[self.btnGoToWorkspace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickGoToWorkSiteButton];
    }];
    
    [self.imgHomeOwner setUserImageWithId:nil];
}

- (void)initWithRequirement:(Requirement *)requirement {
    self.requirement = requirement;
    [self updateRequirement:requirement];
    
    [self.requirementDataManager refreshOrderedDesigners:requirement];
    @weakify(self);
    [self.requirementDataManager.orderedDesigners enumerateObjectsUsingBlock:^(Designer*  _Nonnull orderedDesigner, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self updateDesigner:orderedDesigner forIndex:idx];
    }];
}

- (void)tapDesignerAvatar:(UIGestureRecognizer*)gestureRecognizer {
    NSInteger touchedIndex = -1;
    for (UIImageView *imageView in self.designerAvatar) {
        touchedIndex++;
        if (gestureRecognizer.view == imageView) {
            break;
        }
    }
    
    if (touchedIndex == -1) {
        return;
    }
    
    NSString *status = self.currentPlanStatus[touchedIndex];
    if ([status isEqualToString:kPlanStatusUnorder]) {
        [ViewControllerContainer showOrderDesigner:self.requirement];
    } else {
        [ViewControllerContainer showOrderedDesigner:self.requirement];
    }
}

- (void)onClickGoToWorkSiteButton {
    if ([kRequirementStatusConfiguredWorkSite isEqualToString:self.currentRequirementStatus]) {
        [ViewControllerContainer showProcess:self.requirement.process._id];
    } else {
        [ViewControllerContainer showProcessPreview];
    }
}

- (void)updateDesigner:(Designer *)orderedDesigner forIndex:(NSUInteger)idx {
    UIImageView *imgView = self.designerAvatar[idx];
    [imgView setImageWithId:orderedDesigner.imageid withWidth:imgView.bounds.size.width];
    
    UILabel *lblName = self.designerName[idx];
    lblName.text = orderedDesigner.username;
    
    UILabel *lblStatus = self.designerStatus[idx];
    UIImageView *authIcon = self.authIcon[idx];
    
    lblStatus.text = [NameDict nameForPlanStatus:orderedDesigner.plan.status];
    [DesignerBusiness setV:authIcon withAuthType:orderedDesigner.auth_type];
    
    NSString *status = orderedDesigner.plan.status;
    self.currentPlanStatus[idx] = status;
    
    if ([status isEqualToString:kPlanStatusHomeOwnerOrderedWithoutResponse]
        || [status isEqualToString:kPlanStatusDesignerRespondedWithoutMeasureHouse]
        || [status isEqualToString:kPlanStatusDesignerMeasureHouseWithoutPlan]
        || [status isEqualToString:kPlanStatusDesignerSubmittedPlan]) {
        lblStatus.textColor = OrderedColor;
    } else if ([status isEqualToString:kPlanStatusPlanWasChoosed]) {
        lblStatus.textColor = PlanChoosedColor;
    } else if ([status isEqualToString:kPlanStatusDesignerDeclineHomeOwner]
               || [status isEqualToString:kPlanStatusPlanWasNotChoosed]
               || [status isEqualToString:kPlanStatusExpiredAsDesignerDidNotRespond]) {
        lblStatus.textColor = UnorderColor;
    }
}

- (void)updateRequirement:(Requirement *)requirement {
    self.currentRequirementStatus = requirement.status;
    self.lblRequirementStatusVal.text = [NameDict nameForRequirementStatus:requirement.status];
    self.lblPubulishTimeVal.text = [NSDate yyyy_MM_dd:requirement.create_at];
    self.lblUpdateTimeVal.text = [NSDate yyyy_MM_dd:requirement.last_status_update_time];
    
    NSString *status = requirement.status;
    
    if ([status isEqualToString:kRequirementStatusOrderedDesignerWithoutAnyResponse]
        || [status isEqualToString:kRequirementStatusDesignerRespondedWithoutMeasureHouse]
        || [status isEqualToString:kRequirementStatusPlanWasChoosedWithoutAgreement]
        || [status isEqualToString:kRequirementStatusDesignerMeasureHouseWithoutPlan]
        || [status isEqualToString:kRequirementStatusConfiguredAgreementWithoutWorkSite]) {
        self.lblRequirementStatusVal.textColor = OrderedColor;
    } else if ([status isEqualToString:kRequirementStatusConfiguredWorkSite]) {
        self.lblRequirementStatusVal.textColor = PlanChoosedColor;
        self.btnGoToWorkspace.titleLabel.textColor = PlanChoosedColor;
        [self.btnGoToWorkspace setTitle:@"前往工地" forState:UIControlStateNormal];
    } else if ([status isEqualToString:kRequirementStatusUnorderAnyDesigner]) {
        self.lblRequirementStatusVal.textColor = UnorderColor;
    }
}

@end
