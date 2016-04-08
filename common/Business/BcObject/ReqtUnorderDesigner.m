//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ReqtUnorderDesigner.h"

@implementation ReqtUnorderDesigner

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kRequirementStatusUnorderAnyDesigner action:action];
}

@end
