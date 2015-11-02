//
//  NSArray+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "NSArray+Ex.h"

@implementation NSArray (Ex)

- (NSArray *)map:(id (^)(id obj))fun {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id obj in self) {
        [array addObject:fun(obj)];
    }
    
    return array;
}

@end
