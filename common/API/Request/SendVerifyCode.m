//
//  SendVerifyCode.m
//  jianfanjia
//
//  Created by JYZ on 15/8/24.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "SendVerifyCode.h"
#import "API.h"

@implementation SendVerifyCode

- (void)setphone:(NSString *)phone {
    [self.data setObject:phone forKey:@"phone"];
}

@end
