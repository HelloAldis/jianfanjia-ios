//
//  NSArray+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "NSArray+Ex.h"

@implementation NSArray (Ex)

- (NSMutableArray *)map:(id (^)(id obj))fun {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id obj in self) {
        id covertObj = fun(obj);
        if (covertObj) {
            [array addObject:covertObj];
        }
    }
    
    return array;
}

- (NSString *)join:(NSString *)join {
    if (self.count == 0) {
        return @"";
    } else {
        NSMutableString *muStr = [[NSMutableString alloc] init];
        for (int i = 0; i < self.count; i++) {
            NSString *s = [self objectAtIndex:i] ? [self objectAtIndex:i] : @"";
            if (i == self.count - 1) {
                [muStr appendString:s];
            } else {
                [muStr appendFormat:@"%@%@", s, join];
            }
        }
        
        return muStr;
    }
}

@end
