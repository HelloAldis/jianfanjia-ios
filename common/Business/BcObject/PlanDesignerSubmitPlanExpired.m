//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PlanDesignerSubmitPlanExpired.h"

@implementation PlanDesignerSubmitPlanExpired

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kPlanStatusExpiredAsDesignerDidNotProvidePlanInSpecifiedTime action:action];
}

@end
