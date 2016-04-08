//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ElseStatus.h"

@implementation ElseStatus

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kElseStatus action:action];
}

@end
