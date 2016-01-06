//
//  BindPhone.m
//  jianfanjia
//
//  Created by Karos on 16/1/6.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BindPhone.h"

@implementation BindPhone

@dynamic phone;
@dynamic code;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

@end
