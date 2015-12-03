//
//  Reschedule.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule

@dynamic _id;
@dynamic request_date;
@dynamic processid;
@dynamic userid;
@dynamic designerid;
@dynamic section;
@dynamic updated_date;
@dynamic request_role;
@dynamic status;

- (id)objectForKey:(NSString *)key {
    if ([@"updated_date" isEqualToString:key]) {
        return [[self data] objectForKey:@"new_date"];
    } else {
        return [super objectForKey:key];
    }
}

@end
