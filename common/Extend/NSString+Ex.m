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

- (BOOL)isEmpty {
    if([self length] == 0) { //string is empty or nil
        return YES;
    }
    
    if([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}

- (NSString *)hmacSha1:(NSString *)secret {
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], cHMAC);
    
    return [[[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)replaceEmptyToPlus {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (NSString *)add:(NSInteger)add {
    NSInteger i = [self integerValue];
    NSNumber *number = @(i + add);
    return [number stringValue];
}

- (NSSet *)tags {
    NSArray *array = [self componentsSeparatedByString:@","];
    NSMutableSet *tags = [[NSMutableSet alloc] initWithCapacity:array.count];
    
    if (array == nil) {
        return tags;
    }
    
    for (NSString *tag in array) {
        if (![@"none" isEqualToString:[tag lowercaseString]] && ![tag isEmpty]) {
            [tags addObject:tag];
        }
    }
    
    return tags;
}

- (BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (NSAttributedString *)attrStrWithFont:(UIFont *)font color:(UIColor *)color {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedStr setAttributes:@{NSFontAttributeName:font,
                                   NSForegroundColorAttributeName:color,
                                   }
                           range:NSMakeRange(0, self.length)];
    return attributedStr;
}

- (NSAttributedString *)attrSubStr:(NSString *)subStr font:(UIFont *)font color:(UIColor *)color {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedStr setAttributes:@{NSFontAttributeName:font,
                                   NSForegroundColorAttributeName:color,
                                   }
                           range:[self rangeOfString:subStr]];
    return attributedStr;
}

+ (BOOL)compareStrWithIgnoreNil:(NSString *)aString other:(NSString *)bString {
    return [aString ? aString : @"" isEqualToString:bString ? bString : @""];
}

@end
