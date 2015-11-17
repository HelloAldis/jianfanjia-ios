//
//  Requirement.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Requirement.h"

@implementation Requirement

@dynamic _id;
@dynamic province;
@dynamic city;
@dynamic district;
@dynamic street;
@dynamic cell;
@dynamic cell_phase;
@dynamic cell_building;
@dynamic cell_unit;
@dynamic cell_detail_number;
@dynamic house_type;
@dynamic dec_type;
@dynamic house_area;
@dynamic dec_style;
@dynamic work_type;
@dynamic total_price;
@dynamic prefer_sex;
@dynamic family_description;
@dynamic order_designerids;
@dynamic rec_designers;

- (MatchedDesigner *)matchedDesignerAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.rec_designers.count) {
        NSMutableDictionary *dict = [self.rec_designers objectAtIndex:index];
        return [[MatchedDesigner alloc] initWith:dict];
    } else {
        return nil;
    }
}

@end
