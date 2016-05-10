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
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *designerView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *tagView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblTag;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgHanging;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *designerAvatar;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *authIcon;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *designerName;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *designerStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblRequirementStatusVal;
@property (weak, nonatomic) IBOutlet UIButton *btnGoToWorkspace;
@property (weak, nonatomic) RACDisposable *btnGoToDisposable;

@property (strong, nonatomic) NSMutableArray *currentPlanStatus;
@property (strong, nonatomic) RequirementDataManager *dataManager;
@property (strong, nonatomic) Requirement *requirement;
@property (assign, nonatomic) BOOL isJiangXin;

@end

@implementation RequirementCell

- (void)awakeFromNib {
    self.clipsToBounds = YES;
    self.dataManager = [[RequirementDataManager alloc] init];
    self.currentPlanStatus = [[NSMutableArray alloc] initWithCapacity:self.designerAvatar.count];
    
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderView:)]];
    
    @weakify(self);
    [self.designerStatus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self.currentPlanStatus addObject:kPlanStatusUnorder];
    }];
    
    [self.designerAvatar enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDesignerAvatar:)];
        [imageView setCornerRadius:imageView.bounds.size.width / 2];
        [imageView addGestureRecognizer:gesture];
    }];
    
    [self.tagView enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setCornerRadius:obj.bounds.size.height / 2];
    }];
    
    [self.imgHomeOwner setCornerRadius:self.imgHomeOwner.bounds.size.width / 2];
}

- (void)initWithRequirement:(Requirement *)requirement {
    [self.imgHomeOwner setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
    self.requirement = requirement;
    
    self.isJiangXin = [RequirementBusiness isPkgJiangXinByType:requirement.package_type];
    [self updateDesignerView:self.isJiangXin];
    [self updateRequirement:requirement];
    
    [self.dataManager refreshOrderedDesigners:requirement];
    if (self.isJiangXin) {
        if (self.dataManager.orderedDesigners.count > 0) {
            [self updateDesigner:self.dataManager.orderedDesigners[0] forIndex:1];
        } else {
            [self updateDesigner:nil forIndex:1];
        }
    } else {
        for (NSInteger i = 0; i < self.designerAvatar.count; i++) {
            if (i < self.dataManager.orderedDesigners.count) {
                [self updateDesigner:self.dataManager.orderedDesigners[i] forIndex:i];
            } else {
                [self updateDesigner:nil forIndex:i];
            }
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

#pragma mark - update status
- (void)updateDesigner:(Designer *)orderedDesigner forIndex:(NSUInteger)idx {
    BOOL ordered = orderedDesigner != nil;
    UIImageView *imgView = self.designerAvatar[idx];
    imgView.tintColor = ordered ? nil : (self.isJiangXin ? kThemeColor: [UIColor grayColor]);
    [imgView setBorder:ordered ? (self.isJiangXin ? 1 : 0) : 0 andColor:kThemeColor.CGColor];
    
    UIImageView *imgHandings = self.imgHanging[idx];
    imgHandings.hidden = !self.isJiangXin;
    
    if (ordered) {
        [imgView setImageWithId:orderedDesigner.imageid withWidth:imgView.bounds.size.width];
    } else {
        [imgView setImage:[UIImage imageNamed:@"icon_add_designer"]];
        imgHandings.hidden = YES;
    }
    
    UILabel *lblName = self.designerName[idx];
    lblName.text = orderedDesigner ? orderedDesigner.username : (self.isJiangXin ? @"匠心定制设计师" : @"设计师");
    
    NSString *status = orderedDesigner ? orderedDesigner.plan.status : kPlanStatusUnorder;
    NSString *auth_type = orderedDesigner ? orderedDesigner.auth_type : kAuthTypeUnsubmitVerify;
    
    UILabel *lblStatus = self.designerStatus[idx];
    UIImageView *authIcon = self.authIcon[idx];
    
    UILabel *lblTag = self.lblTag[idx];
    lblTag.text = [DesignerBusiness designerTagTextByArr:orderedDesigner.tags];
    
//    UIView *tagView = self.tagView[idx];
//    tagView.bgColor = [DesignerBusiness designerTagColorByArr:orderedDesigner.tags];
//    tagView.hidden = self.isJiangXin;

    [DesignerBusiness setV:authIcon withAuthType:auth_type];
    self.currentPlanStatus[idx] = status;
    
    //更新设计师状态
    lblStatus.text = [status isEqualToString:kPlanStatusUnorder] ? @"未预约" : [NameDict nameForPlanStatus:status];
    [StatusBlock matchPlan:status actions:
     @[[PlanWasChoosed action:^{
            lblStatus.text = [PlanWasChoosed text:self.requirement.status workType:self.requirement.work_type];
            lblStatus.textColor = [PlanWasChoosed textColor:self.requirement.status workType:self.requirement.work_type];
        }],
       [PlanHomeOwnerOrdered action:^{
            lblStatus.textColor = kExcutionStatusColor;
        }],
       [PlanDesignerMeasuredHouse action:^{
            lblStatus.textColor = kExcutionStatusColor;
        }],
       [PlanDesignerSubmittedPlan action:^{
            lblStatus.textColor = kExcutionStatusColor;
        }],
       [PlanDesignerResponded action:^{
            lblStatus.text = [PlanDesignerResponded text:orderedDesigner.plan.house_check_time];
            lblStatus.textColor = kExcutionStatusColor;
        }],
       [ElseStatus action:^{
            lblStatus.textColor = kUntriggeredColor;
        }],
       ]];

    
    if (!self.isJiangXin) {
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
}

- (void)updateRequirement:(Requirement *)requirement {
    self.lblPubulishTimeVal.text = [NSDate yyyy_MM_dd:requirement.create_at];
    self.lblUpdateTimeVal.text = [NSDate yyyy_MM_dd:requirement.last_status_update_time];
    self.lblCellNameVal.text = requirement.basic_address;
    
    NSString *status = requirement.status;
    [StatusBlock matchReqt:status actions:
     @[[ReqtUnorderDesigner action:^{
            self.lblRequirementStatusVal.textColor = kUntriggeredColor;
            NSString *text = self.isJiangXin ? @"请点击前往预约1名匠心定制设计师" : @"已为您匹配3名设计师请点击前往预约";
            [self updateGoToWorksite:text titleColor:kFinishedColor];
            [self gotoShowOrderDesigner];
        }],
       [ReqtConfiguredAgreement action:^{
            self.lblRequirementStatusVal.textColor = kFinishedColor;
            [self updateGoToWorksite:@"查看合同" titleColor:kFinishedColor];
            [self gotoShowAgreement];
        }],
       [ReqtPlanWasChoosed action:^{
            self.lblRequirementStatusVal.textColor = kPassStatusColor;
            [self updateGoToWorksite:@"查看合同" titleColor:kFinishedColor];
            [self gotoShowAgreement];
        }],
       [ReqtConfiguredWorkSite action:^{
            self.lblRequirementStatusVal.textColor = kFinishedColor;
            [self updateGoToWorksite:@"前往工地" titleColor:kFinishedColor];
            [self gotoShowWorksite];
        }],
       [ReqtFinishedWorkSite action:^{
            self.lblRequirementStatusVal.textColor = kPassStatusColor;
            [self updateGoToWorksite:@"前往工地" titleColor:kFinishedColor];
            [self gotoShowWorksite];
        }],
       [ElseStatus action:^{
            [self configGotoByPlanStatus];
        }],
      ]];
}

#pragma mark - other
- (void)designerAction:(NSString *)status canNotOrder:(void (^)(void))canNotOrder order:(void (^)(void))order ordered:(void (^)(void))ordered {
    [StatusBlock matchPlan:status actions:
     @[[PlanUnorder action:^{
            NSString *reqStatus = self.requirement.status;
            [StatusBlock matchReqt:reqStatus actions:
             @[[ReqtPlanWasChoosed action:^{
                    if (canNotOrder) canNotOrder();
                }],
                [ReqtConfiguredAgreement action:^{
                    if (canNotOrder) canNotOrder();
                }],
               [ReqtConfiguredWorkSite action:^{
                    if (canNotOrder) canNotOrder();
                }],
                [ReqtFinishedWorkSite action:^{
                    if (canNotOrder) canNotOrder();
                }],
                [ElseStatus action:^{
                    if (order) order();
                }],
               ]];
        }],
        [ElseStatus action:^{
            if (ordered) ordered();
        }],
       ]];
}

- (void)enableDesigner:(BOOL)enable index:(NSUInteger)idx {
    UIImageView *imgView = self.designerAvatar[idx];
    UILabel *lblName = self.designerName[idx];
    
    imgView.userInteractionEnabled = enable;
    imgView.tintColor = enable? [UIColor grayColor] : kUntriggeredColor;
    lblName.textColor = enable ? kThemeTextColor : kUntriggeredColor;
}

- (void)updateGoToWorksite:(NSString *)title titleColor:(UIColor *)titleColor {
    [self.btnGoToWorkspace setNormTitleColor:titleColor];
    [self.btnGoToWorkspace setNormTitle:title];
}

- (void)updateDesignerView:(BOOL)isJiangXin {
    if (isJiangXin) {
        [self.designerView[0] setHidden:YES];
        [self.designerView[1] setHidden:NO];
        [self.designerView[2] setHidden:YES];
    } else {
        [self.designerView[0] setHidden:NO];
        [self.designerView[1] setHidden:NO];
        [self.designerView[2] setHidden:NO];
    }
}

#pragma mark - Go to workspace function
- (void)updateGotoBlock:(void (^)(void))gotoBlock {
    [self.btnGoToDisposable dispose];
    self.btnGoToDisposable = [[self.btnGoToWorkspace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (gotoBlock) {
            gotoBlock();
        }
    }];
}

- (void)gotoShowWorksite {
    @weakify(self);
    [self updateGotoBlock:^{
        @strongify(self);
        [ViewControllerContainer showProcess:self.requirement.process._id];
    }];
}

- (void)gotoShowOrderDesigner {
    @weakify(self);
    [self updateGotoBlock:^{
        @strongify(self);
        [ViewControllerContainer showOrderDesigner:self.requirement];
    }];
}

- (void)gotoShowOrderedDesigner {
    @weakify(self);
    [self updateGotoBlock:^{
        @strongify(self);
        [ViewControllerContainer showOrderedDesigner:self.requirement];
    }];
}

- (void)gotoShowPreviewWorksite {
    [self updateGotoBlock:^{
        [ViewControllerContainer showProcessPreview];
    }];
}

- (void)gotoShowAgreement {
    @weakify(self);
    [self updateGotoBlock:^{
        @strongify(self);
        [ViewControllerContainer showAgreement:self.requirement popTo:[ViewControllerContainer getCurrentTapController] refresh:nil];
    }];
}

- (void)configGotoByPlanStatus {
    static NSArray *actionStatus;
    actionStatus = @[kPlanStatusDesignerRespondedWithoutMeasureHouse, kPlanStatusDesignerSubmittedPlan];
    
    __block NSInteger actionIndex = -1;
    [self.dataManager.orderedDesigners enumerateObjectsUsingBlock:^(Designer *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *status = obj.plan.status;
        if ([actionStatus containsObject:status]) {
            actionIndex = idx;
            *stop = YES;
        }
    }];
    
    if (actionIndex != -1) {
        self.lblRequirementStatusVal.textColor = kFinishedColor;
        [self updateGoToWorksite:@"设计师有新动态，请点击查看" titleColor:kFinishedColor];
        [self gotoShowOrderedDesigner];
    } else {
        self.lblRequirementStatusVal.textColor = kPassStatusColor;
        [self updateGoToWorksite:@"预览工地" titleColor:kThemeTextColor];
        [self gotoShowPreviewWorksite];
    }
}

@end
