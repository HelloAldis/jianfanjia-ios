//
//  DesignerStatusCell.m
//  jianfanjia
//
//  Created by Karos on 16/8/12.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DesignerStatusCell.h"
#import "ViewControllerContainer.h"

@interface DesignerStatusCell ()

@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;
@property (weak, nonatomic) IBOutlet UIImageView *imgHanging;
@property (weak, nonatomic) IBOutlet UIImageView *designerAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *designerName;
@property (weak, nonatomic) IBOutlet UILabel *designerStatus;

@property (weak, nonatomic) Designer *designer;
@property (weak, nonatomic) Requirement *requirement;

@end

@implementation DesignerStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.designerAvatar setCornerRadius:self.designerAvatar.bounds.size.width / 2];
    [self.tagView setCornerRadius:self.tagView.bounds.size.height / 2];
    
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDesignerAvatar:)];
    [self addGestureRecognizer:gesture];
}

- (void)initWithDesigner:(Designer *)designer requirement:(Requirement *)requirement {
    self.designer = designer;
    self.requirement = requirement;
    
    BOOL isJiangXin = [DesignerBusiness containsJiangXinDingZhiTag:self.designer.tags];
    [self.designerAvatar setBorder:isJiangXin ? 1 : 0 andColor:kThemeColor.CGColor];
    [self.designerAvatar setImageWithId:self.designer.imageid withWidth:self.designerAvatar.bounds.size.width];
    self.imgHanging.hidden = !isJiangXin;
    self.designerName.text = self.designer ? self.designer.username : (isJiangXin ? @"匠心定制设计师" : @"设计师");
    self.lblTag.text = [DesignerBusiness designerTagTextByArr:self.designer.tags];
    [DesignerBusiness setV:self.authIcon withAuthType:self.designer.auth_type];
    
    //更新设计师状态
    NSString *status = self.designer.plan.status;
    UILabel *lblStatus = self.designerStatus;
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
            lblStatus.text = [PlanDesignerResponded text:self.designer.plan.house_check_time];
            lblStatus.textColor = kExcutionStatusColor;
        }],
       [ElseStatus action:^{
            lblStatus.textColor = kUntriggeredColor;
        }],
       ]];
}

- (void)tapDesignerAvatar:(UIGestureRecognizer*)gestureRecognizer {
    [ViewControllerContainer showDesigner:self.designer._id];
}

@end
