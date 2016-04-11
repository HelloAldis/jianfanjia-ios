//
//  ReqtUnorderAnyDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PlanWasChoosed.h"

@implementation PlanWasChoosed

+ (StatusBlock *)action:(StatusBlockAction)action {
    return [StatusBlock match:kPlanStatusPlanWasChoosed action:action];
}

+ (NSString *)text:(NSString *)reqtStatus {
    __block NSString *text = nil;
    
    [StatusBlock matchReqt:reqtStatus actions:
     @[[ReqtConfiguredAgreement action:^{
            text = @"等待确认合同";
        }],
       [ReqtPlanWasChoosed action:^{
            text = @"等待配置合同";
        }],
       [ReqtFinishedWorkSite action:^{
            text = @"已竣工";
        }],
       [ElseStatus action:^{
            text = @"已开工";
        }],
       ]];
    
    return text;
}

+ (UIColor *)textColor:(NSString *)reqtStatus {
    __block UIColor *textColor = nil;
    
    [StatusBlock matchReqt:reqtStatus actions:
     @[[ReqtConfiguredAgreement action:^{
            textColor = kExcutionStatusColor;
        }],
       [ReqtPlanWasChoosed action:^{
            textColor = kExcutionStatusColor;
        }],
       [ReqtFinishedWorkSite action:^{
            textColor = kPassStatusColor;
        }],
       [ElseStatus action:^{
            textColor = kFinishedColor;
        }],
       ]];
    
    return textColor;
}

@end
