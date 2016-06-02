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

- (BOOL)isValidateEmail;
- (NSString *)lowercaseFirstLetterString;
- (NSString *)substringWithoutLast:(NSUInteger)last;
- (BOOL)isEmpty;
- (NSString *)trim;

- (NSMutableAttributedString *)attrStrWithFont:(UIFont *)font color:(UIColor *)color;
- (NSMutableAttributedString *)attrSubStr:(NSString *)subStr font:(UIFont *)font color:(UIColor *)color;
- (NSMutableAttributedString *)attrSubStr1:(NSString *)subStr1 font1:(UIFont *)font1 color1:(UIColor *)color1 subStr2:(NSString *)subStr2 font2:(UIFont *)font2 color2:(UIColor *)color2;

+ (BOOL)compareStrWithIgnoreNil:(NSString *)aString other:(NSString *)bString;
+ (CGSize)sizeWithConstrainedSize:(CGSize)constrainedSize font:(UIFont *)font maxLength:(NSInteger)maxLength;

@end
