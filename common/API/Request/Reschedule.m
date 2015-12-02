//
//  Reschedule.m
//  jianfanjia
//
//  Created by likaros on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Reschedule.h"

@implementation Reschedule

@dynamic processid;
@dynamic userid;
@dynamic designerid;
@dynamic section;
@dynamic updated_date;

- (void)setObject:(id)o forKey:(NSString *)key {
    if ([@"updated_date" isEqualToString:key]) {
        [[self data] setObject:o forKey:@"new_date"];
    } else {
        [[self data] setObject:o forKey:key];
    }
}


@end
