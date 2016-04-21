//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PlanDesignerResponded.h"

@implementation PlanDesignerResponded

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kPlanStatusDesignerRespondedWithoutMeasureHouse action:action];
}

+ (NSString *)text:(NSNumber *)checkTime {
    if ([self isNowMoreThanCheckTime:checkTime]) {
        return @"等待确认量房";
    } else {
        return @"等待量房";
    }
}

+ (BOOL)isNowMoreThanCheckTime:(NSNumber *)checkTime {
    return [[NSDate date] timeIntervalSince1970] > checkTime.longLongValue / 1000;
}

@end
