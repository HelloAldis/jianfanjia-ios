//
//  MatchDesignerCell.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignerPlanStatusBaseCell.h"

@interface PlanWasChoosedForDesignCell : DesignerPlanStatusBaseCell

- (void)initWithDesigner:(Designer *)designer withRequirement:(Requirement *)requirement withBlock:(PlanStatusRefreshBlock)refreshBlock;

@end
