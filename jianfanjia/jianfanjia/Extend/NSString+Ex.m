//
//  NSString+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/9/1.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "NSString+Ex.h"

@implementation NSString (EX)

/*
 Description: Change the first letter of a string to lowercase.
 */
-(NSString *)lowercaseFirstLetterString
{
    if (self.length>0) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] lowercaseString]];
    }
    return self;
}

/*
 Description: Get string from the begining to the given index.
 */
-(NSString *)substringWithoutLast:(NSUInteger)last
{
    if (last<=self.length) {
        return [self substringToIndex:self.length-last];
    }
    return @"";
}

@end
