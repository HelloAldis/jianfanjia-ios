//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ReqtDesignerMeasuredHouse.h"

@implementation ReqtDesignerMeasuredHouse

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kRequirementStatusDesignerMeasureHouseWithoutPlan action:action];
}

@end
