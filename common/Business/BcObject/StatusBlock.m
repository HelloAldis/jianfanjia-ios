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
    [actions enumerateObjectsUsingBlock:^(StatusBlock * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([status isEqualToString:obj.status]) {
            if (obj.actionBlock) {
                obj.actionBlock();
            }
            *stop = YES;
        }
    }];
}

@end
