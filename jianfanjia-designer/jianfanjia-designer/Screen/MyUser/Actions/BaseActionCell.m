//
//  BaseActionCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/1/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseActionCell.h"
#import "ViewControllerContainer.h"

@implementation BaseActionCell

- (void)initWithRequirement:(Requirement *)requirement actionBlock:(ActionBlock)actionBlock {
    self.requirement = requirement;
    self.actionBlock = actionBlock;
}

- (void)initHeaderData:(UIImageView *)imgHomeOwner gender:(UIImageView *)imgUserGender name:(UILabel *)lblUserName cell:(UILabel *)lblCellNameVal info:(UILabel *)lblRequirementfInfo updateTime:(UILabel *)lblUpdateTimeVal {
    [imgHomeOwner setUserImageWithId:_requirement.user.imageid];
    imgUserGender.image = [_requirement.user.sex isEqualToString:@"1"] ? [UIImage imageNamed:@"icon_user_woman"] : [UIImage imageNamed:@"icon_user_man"];
    lblUserName.text = _requirement.user.username;
    lblCellNameVal.text = [_requirement.dec_type isEqualToString:kDecTypeHouse] ? [NSString stringWithFormat:@"%@%@期", _requirement.cell, _requirement.cell_phase] : _requirement.cell;
    lblRequirementfInfo.text = [NSString stringWithFormat:@"%@, %@m², %@, 装修预算%@万", [NameDict nameForHouseType:_requirement.house_type], _requirement.house_area, [NameDict nameForDecStyle:_requirement.dec_style], _requirement.total_price];
    lblUpdateTimeVal.text = [_requirement.plan.last_status_update_time humDateString];
}

#pragma mark - gestures
- (void)handleTapHeaderView:(UIGestureRecognizer*)gestureRecognizer {
    [ViewControllerContainer showRequirementCreate:self.requirement];
}

#pragma mark - user action
- (void)onClickViewPlan {
    [ViewControllerContainer showPlanList:self.requirement];
}

- (void)onClickContact {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.requirement.user.phone message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //Do nothing
    }];
    
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://86%@", self.requirement.user.phone]]];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
