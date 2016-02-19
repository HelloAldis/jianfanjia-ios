//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerSimpleInfoCell.h"
#import "ViewControllerContainer.h"

@interface DesignerSimpleInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserGender;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblCellNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblRequirementfInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTimeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnEditRequirement;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAgreement;
@property (weak, nonatomic) IBOutlet UILabel *lblViewAgreement;
@property (weak, nonatomic) IBOutlet UIImageView *iconViewAgreement;
@property (weak, nonatomic) IBOutlet UIButton *btnViewPlan;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;

@property (strong, nonatomic) Designer *designer;

@end

@implementation DesignerSimpleInfoCell

- (void)awakeFromNib {
    [self.imgHomeOwner setCornerRadius:self.imgHomeOwner.bounds.size.width / 2];
}

- (void)initWithDesigner:(Designer *)designer {

}

#pragma mark - user action


@end
