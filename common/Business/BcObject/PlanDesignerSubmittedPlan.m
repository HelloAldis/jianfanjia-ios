//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PlanDesignerSubmittedPlan.h"

@implementation PlanDesignerSubmittedPlan

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kPlanStatusDesignerSubmittedPlan action:action];
}

@end
