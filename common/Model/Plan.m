//
//  Plan.m
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Plan.h"

@implementation Plan

@dynamic _id;
@dynamic name;
@dynamic designerid;
@dynamic requirementid;
@dynamic userid;
@dynamic status;
@dynamic house_check_time;
@dynamic last_status_update_time;
@dynamic request_date;
@dynamic project_price_before_discount;
@dynamic total_design_fee;
@dynamic project_price_after_discount;
@dynamic total_price;
@dynamic duration;
@dynamic manager;
@dynamic plan_description;
@dynamic comment_count;
@dynamic images;
@dynamic reject_respond_msg;

- (void)setObject:(id)o forKey:(NSString *)key {
    if ([@"plan_description" isEqualToString:key]) {
        [[self data] setObject:o forKey:@"description"];
    } else {
        [[self data] setObject:o forKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    if ([@"plan_description" isEqualToString:key]) {
        return [[self data] objectForKey:@"description"];
    } else {
        return [[self data] objectForKey:key];
    }
}

@end
