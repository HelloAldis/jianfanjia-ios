//
//  VerifyPhone.m
//  jianfanjia
//
//  Created by JYZ on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "VerifyPhone.h"

@implementation VerifyPhone

@dynamic phone;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

@end
