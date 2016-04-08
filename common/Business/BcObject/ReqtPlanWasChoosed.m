//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ReqtPlanWasChoosed.h"

@implementation ReqtPlanWasChoosed

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kRequirementStatusPlanWasChoosedWithoutAgreement action:action];
}

@end
