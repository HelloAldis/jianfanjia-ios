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
@property (weak, nonatomic) IBOutlet UIView *headerView;
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
    self.clipsToBounds = YES;
    self.requirementDataManager = [[RequirementDataManager alloc] init];
    self.currentPlanStatus = [[NSMutableArray alloc] initWithCapacity:self.designerAvatar.count];
    
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderView:)]];
    
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
    
    [self.imgHomeOwner setCornerRadius:self.imgHomeOwner.bounds.size.width / 2];
}

- (void)initWithRequirement:(Requirement *)requirement {
    self.requirement = requirement;
    [self updateRequirement:requirement];
    [self.imgHomeOwner setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
    
    [self.requirementDataManager refreshOrderedDesigners:requirement];
    
    for (NSInteger i = 0; i < self.designerAvatar.count; i++) {
        if (i < self.requirementDataManager.orderedDesigners.count) {
            [self updateDesigner:self.requirementDataManager.orderedDesigners[i] forIndex:i];
        } else {
            [self updateDesigner:nil forIndex:i];
        }
    }
}

#pragma mark - gestures
- (void)handleTapHeaderView:(UIGestureRecognizer*)gestureRecognizer {
    [ViewControllerContainer showRequirementCreate:self.requirement];
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
    @weakify(self);
    [self designerAction:status canNotOrder:nil order:^{
        @strongify(self);
        [ViewControllerContainer showOrderDesigner:self.requirement];
    } ordered:^{
        @strongify(self);
        [ViewControllerContainer showOrderedDesigner:self.requirement];
    }];
}

#pragma mark - user action
- (void)onClickGoToWorkSiteButton {
    if ([kRequirementStatusConfiguredWorkSite isEqualToString:self.currentRequirementStatus]
        || [kRequirementStatusFinishedWorkSite isEqualToString:self.currentRequirementStatus]) {
        [ViewControllerContainer showProcess:self.requirement.process._id];
    } else {
        [ViewControllerContainer showProcessPreview];
    }
}

#pragma mark - update status
- (void)updateDesigner:(Designer *)orderedDesigner forIndex:(NSUInteger)idx {
    UIImageView *imgView = self.designerAvatar[idx];
    
    if (orderedDesigner) {
        [imgView setImageWithId:orderedDesigner.imageid withWidth:imgView.bounds.size.width];
    } else {
        [imgView setImage:[UIImage imageNamed:@"icon_add_designer"]];
    }
    
    UILabel *lblName = self.designerName[idx];
    lblName.text = orderedDesigner ? orderedDesigner.username : @"设计师";
    
    NSString *status = orderedDesigner ? orderedDesigner.plan.status : kPlanStatusUnorder;
    NSString *auth_type = orderedDesigner ? orderedDesigner.auth_type : kAuthTypeUnsubmitVerify;
    
    UILabel *lblStatus = self.designerStatus[idx];
    UIImageView *authIcon = self.authIcon[idx];
    
    lblStatus.text = [status isEqualToString:kPlanStatusUnorder] ? @"未预约" : [NameDict nameForPlanStatus:status];
    [DesignerBusiness setV:authIcon withAuthType:auth_type];
    
    self.currentPlanStatus[idx] = status;
    
    //更新设计师状态
    if ([status isEqualToString:kPlanStatusHomeOwnerOrderedWithoutResponse]) {
        lblStatus.textColor = kPassStatusColor;
    } else if ([status isEqualToString:kPlanStatusPlanWasChoosed]
        || [status isEqualToString:kPlanStatusDesignerMeasureHouseWithoutPlan]
        || [status isEqualToString:kPlanStatusDesignerSubmittedPlan]) {
        lblStatus.textColor = kFinishedColor;
    } else if ([status isEqualToString:kPlanStatusDesignerRespondedWithoutMeasureHouse]) {
        lblStatus.textColor = kExcutionStatusColor;
    } else {
        lblStatus.textColor = kUntriggeredColor;
    }
    
    //判断是否允许继续预约设计师
    @weakify(self);
    [self designerAction:status canNotOrder:^{
        @strongify(self);
        [self enableDesigner:NO index:idx];
    } order:^{
        @strongify(self);
        [self enableDesigner:YES index:idx];
    } ordered:^{
        @strongify(self);
        [self enableDesigner:YES index:idx];
    }];
}

- (void)updateRequirement:(Requirement *)requirement {
    self.currentRequirementStatus = requirement.status;
    self.lblRequirementStatusVal.text = [RequirementBusiness isDesignRequirement:requirement.work_type] && [requirement.status isEqualToString:kRequirementStatusPlanWasChoosedWithoutAgreement] ? @"已完成" : [NameDict nameForRequirementStatus:requirement.status];
    self.lblPubulishTimeVal.text = [NSDate yyyy_MM_dd:requirement.create_at];
    self.lblUpdateTimeVal.text = [NSDate yyyy_MM_dd:requirement.last_status_update_time];
    self.lblCellNameVal.text = requirement.basic_address;
    
    NSString *status = requirement.status;
    if ([status isEqualToString:kRequirementStatusOrderedDesignerWithoutAnyResponse]) {
        self.lblRequirementStatusVal.textColor = kPassStatusColor;
        [self updateGoToWorksite:@"预览工地"];
    } else if ([status isEqualToString:kRequirementStatusDesignerRespondedWithoutMeasureHouse]) {
        self.lblRequirementStatusVal.textColor = kExcutionStatusColor;
        [self updateGoToWorksite:@"预览工地"];
    } else if ([status isEqualToString:kRequirementStatusConfiguredAgreementWithoutWorkSite]
               || [status isEqualToString:kRequirementStatusDesignerMeasureHouseWithoutPlan]
               || [status isEqualToString:kRequirementStatusPlanWasChoosedWithoutAgreement]
               || [status isEqualToString:kRequirementStatusDesignerSubmittedPlanWithoutResponse]) {
        self.lblRequirementStatusVal.textColor = kFinishedColor;
        [self updateGoToWorksite:@"预览工地"];
    } else if ([status isEqualToString:kRequirementStatusConfiguredWorkSite]) {
        self.lblRequirementStatusVal.textColor = kFinishedColor;
        [self updateGoToWorksite:@"前往工地"];
    } else if ([status isEqualToString:kRequirementStatusFinishedWorkSite]) {
        self.lblRequirementStatusVal.textColor = kFinishedColor;
        [self updateGoToWorksite:@"前往工地"];
    } else {
        //0. 未预约任何设计师
        self.lblRequirementStatusVal.textColor = kUntriggeredColor;
        [self updateGoToWorksite:@"预览工地"];
    }
}

#pragma mark - other
- (void)designerAction:(NSString *)status canNotOrder:(void (^)(void))canNotOrder order:(void (^)(void))order ordered:(void (^)(void))ordered {
    if ([status isEqualToString:kPlanStatusUnorder]) {
        NSString *status = self.requirement.status;
        if ([status isEqualToString:kRequirementStatusPlanWasChoosedWithoutAgreement]
            || [status isEqualToString:kRequirementStatusConfiguredAgreementWithoutWorkSite]
            || [status isEqualToString:kRequirementStatusConfiguredWorkSite]
            || [status isEqualToString:kRequirementStatusFinishedWorkSite]) {
            if (canNotOrder) canNotOrder();
        } else {
            if (order) order();
        }
    } else {
        if (ordered) ordered();
    }
}

- (void)enableDesigner:(BOOL)enable index:(NSUInteger)idx {
    UIImageView *imgView = self.designerAvatar[idx];
    UILabel *lblName = self.designerName[idx];
    
    imgView.userInteractionEnabled = enable;
    imgView.tintColor = enable? [UIColor grayColor] : kUntriggeredColor;
    lblName.textColor = enable ? kThemeTextColor : kUntriggeredColor;
}

- (void)updateGoToWorksite:(NSString *)title {
    self.btnGoToWorkspace.titleLabel.textColor = kFinishedColor;
    [self.btnGoToWorkspace setTitle:title forState:UIControlStateNormal];
}

@end
