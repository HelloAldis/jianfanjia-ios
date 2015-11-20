//
//  ReplaceOrderedDesigner.m
//  jianfanjia
//
//  Created by Karos on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ReplaceOrderedDesigner.h"

@implementation ReplaceOrderedDesigner

@dynamic requirementid;
@dynamic old_designerid;
@dynamic replaced_designerid;

- (void)setObject:(id)o forKey:(NSString *)key {
    if ([@"replaced_designerid" isEqualToString:key]) {
        [[self data] setObject:o forKey:@"new_designerid"];
    } else {
        [[self data] setObject:o forKey:key];
    }
}

@end
