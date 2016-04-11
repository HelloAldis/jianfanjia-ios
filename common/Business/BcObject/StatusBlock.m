//
//  StatusBlock.m
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "StatusBlock.h"

NSString * const kElseStatus = @"ElseStatus";

static NSMutableDictionary *statusObjPool = nil;

@implementation StatusBlock

+ (void)initialize {
    if ([self class] == [StatusBlock class]) {
        statusObjPool = [NSMutableDictionary dictionary];
    }
}

+ (StatusBlock *)match:(NSString *)status action:(StatusBlockAction)actionBlock {
    StatusBlock *statusBlock = [statusObjPool objectForKey:status];
    
    if (statusBlock) {
        statusBlock.actionBlock = actionBlock;
        return statusBlock;
    } else {
        statusBlock = [[StatusBlock alloc] init];
        statusBlock.status = status;
        statusBlock.actionBlock = actionBlock;
        
        [statusObjPool setValue:statusBlock forKey:status];
    }
    
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
        
        if (idx == actions.count - 1 && [kElseStatus isEqualToString:obj.status]) {
            if (obj.actionBlock) {
                obj.actionBlock();
            }
            *stop = YES;
        }
    }];
}

@end
