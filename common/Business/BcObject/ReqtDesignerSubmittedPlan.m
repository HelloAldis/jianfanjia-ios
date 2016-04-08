//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ReqtDesignerSubmittedPlan.h"

@implementation ReqtDesignerSubmittedPlan

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kRequirementStatusDesignerSubmittedPlanWithoutResponse action:action];
}

@end
