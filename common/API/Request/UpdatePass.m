//
//  UpdatePass.m
//  jianfanjia
//
//  Created by JYZ on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UpdatePass.h"

@implementation UpdatePass

@dynamic phone;
@dynamic pass;
@dynamic code;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

@end
