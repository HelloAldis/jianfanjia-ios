//
//  NSDictionary+Ex.m
//  jianfanjia
//
//  Created by Karos on 15/12/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "NSDictionary+Ex.h"

@implementation NSDictionary (Ex)

- (NSMutableDictionary *)sortedWithOrder:(BOOL)ascend {
    NSMutableDictionary *orderedDic = [NSMutableDictionary dictionaryWithCapacity:self.count];
    NSArray *orderedKeys = [self.allKeys sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        if ([obj1 compare:obj2] == NSOrderedAscending) {
            return ascend ? NSOrderedAscending : NSOrderedDescending;
        } else if ([obj1 compare:obj2] == NSOrderedDescending) {
            return ascend ? NSOrderedDescending : NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    [orderedKeys enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [orderedDic setValue:[self valueForKey:obj] forKey:obj];
    }];
    
    return orderedDic;
}

@end
