//
//  DesignerPlanStatusBaseCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerPlanStatusBaseCell.h"
#import "ViewControllerContainer.h"

@interface DesignerPlanStatusBaseCell ()

@property (copy, nonatomic) PlanStatusRefreshBlock refreshBlock;

@end

@implementation DesignerPlanStatusBaseCell

- (void)initWithDesigner:(Designer *)designer withRequirement:(Requirement *)requirement withBlock:(PlanStatusRefreshBlock)refreshBlock {
    self.designer = designer;
    self.requirement = requirement;
    self.refreshBlock = refreshBlock;
}

- (void)refresh {
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

- (void)initHeader:(UIImageView *)avatar name:(UILabel *)name tagView:(UIView *)tagView lblTag:(UILabel *)lblTag infoCheck:(UIImageView *)infoCheck stars:(NSArray <UIImageView *> *)evaluatedStars {
    [avatar setImageWithId:self.designer.imageid withWidth:avatar.bounds.size.width];
    name.text = self.designer.username;
    
    tagView.bgColor = [DesignerBusiness designerTagColorByArr:self.designer.tags];
    lblTag.text = [DesignerBusiness designerTagTextByArr:self.designer.tags];
    [DesignerBusiness setV:infoCheck withAuthType:self.designer.auth_type];
    [DesignerBusiness setStars:evaluatedStars withStar:(self.designer.respond_speed.floatValue +  self.designer.service_attitude.floatValue) / 2 fullStar:[UIImage imageNamed:@"star_small"] emptyStar:[UIImage imageNamed:@"star_small_empty"]];
}

- (void)onClickDesignerAvatar {
    [ViewControllerContainer showDesigner:self.designer._id];
}

@end
