//
//  DesignerPlanStatusBaseCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerPlanStatusBaseCell.h"

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

@end
