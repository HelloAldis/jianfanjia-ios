//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PlanExpired.h"

@implementation PlanExpired

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kPlanStatusExpired action:action];
}

@end
