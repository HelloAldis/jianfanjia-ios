//
//  StatusBlock.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "StatusBlock.h"

NSString * const kElseStatus = @"ElseStatus";

@implementation StatusBlock

+ (StatusBlock *)match:(NSString *)status action:(StatusBlockAction)actionBlock {
    StatusBlock *statusBlock = [[StatusBlock alloc] init];
    statusBlock.status = status;
    statusBlock.actionBlock = actionBlock;
    
    return statusBlock;
}

+ (void)matchReqt:(NSString *)status actions:(NSArray <StatusBlock *>*)actions {
    [self matchStatus:status actions:actions];
}

+ (void)matchPlan:(NSString *)status actions:(NSArray <StatusBlock *>*)actions {
    [self matchStatus:status actions:actions];
}

+ (void)matchStatus:(NSString *)status actions:(NSArray <StatusBlock *>*)actions {
    [actions enumerateObjectsUsingBlock:^(StatusBlock * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([status isEqualToString:obj.status]) {
            if (obj.actionBlock) {
                obj.actionBlock();
            }
            *stop = YES;
        }
        
        if (idx == actions.count - 1 && [kElseStatus isEqualToString:obj.status]) {
            if (obj.actionBlock) {
                obj.actionBlock();
            }
            *stop = YES;
        }
    }];
}

+ (void)matchReqt:(NSString *)status action:(StatusBlock *)action {
    [self matchStatus:status action:action];
}

+ (void)matchPlan:(NSString *)status action:(StatusBlock *)action {
    [self matchStatus:status action:action];
}

+ (void)matchStatus:(NSString *)status action:(StatusBlock *)action {
    if ([status isEqualToString:action.status]) {
        if (action.actionBlock) {
            action.actionBlock();
        }
    }
}

@end
