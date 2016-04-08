//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ReqtFinishedWorkSite.h"

@implementation ReqtFinishedWorkSite

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kRequirementStatusFinishedWorkSite action:action];
}

@end
