//
//  NSString+Ex.h
//  jianfanjia
//
//  Created by JYZ on 15/9/1.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonHMAC.h>

@interface NSString (EX)

- (NSString *)lowercaseFirstLetterString;
- (NSString *)substringWithoutLast:(NSUInteger)last;
- (BOOL)isEmpty;
- (NSString *)trim;
+ (BOOL)compareStrWithIgnoreNil:(NSString *)aString other:(NSString *)bString;

@end
