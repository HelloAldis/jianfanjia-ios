//
//  GetProcess.m
//  jianfanjia
//
//  Created by JYZ on 15/9/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "GetProcess.h"

@implementation GetProcess

@dynamic processid;

- (void)failure {
    [HUDUtil hideWait];
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

- (void)success {
//    Process *process = [[Process alloc] initWith:[DataManager shared].data];
}

@end
