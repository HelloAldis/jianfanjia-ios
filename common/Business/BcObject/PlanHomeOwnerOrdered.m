//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PlanHomeOwnerOrdered.h"

@implementation PlanHomeOwnerOrdered

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kPlanStatusHomeOwnerOrderedWithoutResponse action:action];
}

@end
