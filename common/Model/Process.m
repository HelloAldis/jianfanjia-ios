//
//  Process.m
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "Process.h"


@implementation Process

@dynamic _id;
@dynamic userid;
@dynamic final_designerid;
@dynamic final_planid;
@dynamic requirementid;
@dynamic province;
@dynamic city;
@dynamic district;
@dynamic cell;
@dynamic house_type;
@dynamic house_area;
@dynamic dec_style;
@dynamic work_type;
@dynamic total_price;
@dynamic start_at;
@dynamic lastupdate;
@dynamic duration;
@dynamic going_on;
@dynamic sections;

- (Section *)sectionAtIndex:(NSInteger )index {
    if (index >= 0 && index < self.sections.count) {
        NSMutableDictionary *dict = [self.sections objectAtIndex:index];
        return [[Section alloc] initWith:dict];
    } else {
        return nil;
    }
}

@end
