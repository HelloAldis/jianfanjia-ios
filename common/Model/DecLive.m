//
//  Plan.m
//  jianfanjia
//
//  Created by Karos on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecLive.h"

@implementation DecLive

@dynamic _id;
@dynamic lastupdate;
@dynamic create_at;
@dynamic manager;
@dynamic province;
@dynamic city;
@dynamic district;
@dynamic cell;
@dynamic house_type;
@dynamic house_area;
@dynamic dec_style;
@dynamic dec_type;
@dynamic work_type;
@dynamic total_price;
@dynamic start_at;
@dynamic cover_imageid;
@dynamic designerid;
@dynamic declive_description;
@dynamic progress;
@dynamic status;
@dynamic process;

- (void)setObject:(id)o forKey:(NSString *)key {
    if ([@"declive_description" isEqualToString:key]) {
        [[self data] setObject:o forKey:@"description"];
    } else {
        [[self data] setObject:o forKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    if ([@"declive_description" isEqualToString:key]) {
        return [[self data] objectForKey:@"description"];
    } else {
        return [[self data] objectForKey:key];
    }
}

@end
