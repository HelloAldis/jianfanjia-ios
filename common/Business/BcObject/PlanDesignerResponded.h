//
//  ReqtUnorderAnyDesigner.h
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusBlock.h"

@interface PlanDesignerResponded : StatusBlock

+ (StatusBlock *)action:(StatusBlockAction)action;

+ (NSString *)text:(NSNumber *)checkTime;
+ (BOOL)isNowMoreThanCheckTime:(NSNumber *)checkTime;

@end
