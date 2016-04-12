//
//  ReqtUnorderAnyDesigner.h
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusBlock.h"

@interface PlanWasChoosed : StatusBlock

+ (StatusBlock *)action:(StatusBlockAction)action;

+ (NSString *)text:(NSString *)reqtStatus workType:(NSString *)workType;
+ (UIColor *)textColor:(NSString *)reqtStatus workType:(NSString *)workType;

@end
