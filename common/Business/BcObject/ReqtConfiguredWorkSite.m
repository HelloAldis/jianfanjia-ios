//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ReqtConfiguredWorkSite.h"

@implementation ReqtConfiguredWorkSite

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kRequirementStatusConfiguredWorkSite action:action];
}

@end
