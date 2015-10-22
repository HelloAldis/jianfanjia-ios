//
//  ProcessList.m
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ProcessList.h"


@implementation ProcessList

- (void)failure {
    [HUDUtil hideWait];
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

- (void)success {
    NSArray * array = [DataManager shared].data;
    for (NSMutableDictionary *dict in array) {
        Process *process = [[Process alloc] initWith:dict];
        

        [dict removeObjectForKey:@"user"];
        
        if (![GVUserDefaults standardUserDefaults].processid) {
            [GVUserDefaults standardUserDefaults].processid = process._id;
        }
        
//        NSMutableDictionary *userDict = [dict objectForKey:@"user"];
//        User *user = [[User alloc] initWith:userDict];
    }
}

@end
