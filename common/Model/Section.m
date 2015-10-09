//
//  Section.m
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Section.h"


@implementation Section

@dynamic name;
@dynamic start_at;
@dynamic end_at;
@dynamic status;
@dynamic items;

- (Item *)itemAtIndex:(NSInteger )index {
    if (index >= 0 && index < self.items.count) {
        NSMutableDictionary *dict = [self.items objectAtIndex:index];
        return [[Item  alloc] initWith:dict];
    } else {
        return nil;
    }
}

@end
