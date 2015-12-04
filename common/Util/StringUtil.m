//
//  StringUtil.m
//  jianfanjia
//
//  Created by JYZ on 15/12/4.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

+ (NSString *)convertNil2Empty:(NSString *)aStr {
    return aStr ? aStr : @"";
}

@end
