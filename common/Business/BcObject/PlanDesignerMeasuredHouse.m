//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PlanDesignerMeasuredHouse.h"

@implementation PlanDesignerMeasuredHouse

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kPlanStatusDesignerMeasuredHouseWithoutPlan action:action];
}

@end
