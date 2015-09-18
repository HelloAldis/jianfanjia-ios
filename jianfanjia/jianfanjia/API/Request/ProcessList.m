//
//  ProcessList.m
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ProcessList.h"

@implementation ProcessList

- (void)success {
    NSArray * array = [[DataManager shared].response objectForKey:@"data"];
    for (NSMutableDictionary *dict in array) {
        NSString *processid = [dict objectForKey:@"_id"];
        NSMutableDictionary *user = [dict objectForKey:@"user"];
        [dict removeObjectForKey:@"user"];
        Process *process = [[DataManager shared].processDict objectForKey:processid];
        if (process) {
            [process.data addEntriesFromDictionary:dict];
        } else {
            process = [[Process alloc] initWith:dict];
            [[DataManager shared].processDict setObject:process forKey:processid];
        }
    }
}

@end
