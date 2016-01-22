//
//  NSNumber+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/11/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "NSNumber+Ex.h"
//#import "NSDate+Ex.h"

#define kTenDay 864000
#define kOneDay 86400
#define kOneMin 60
#define kOneHour 3600
#define kOneYear (86400*365)

#define kWang 10000
#define kQianWang (10000*1000)
#define kYi (10000*1000*10)

#define kKB 1024
#define kMB (1024*1024)

@implementation NSNumber (Ex)

- (NSString *)humDateString {
    NSDate *now = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue] / 1000];
    
    NSTimeInterval diff = [now timeIntervalSince1970] - [date timeIntervalSince1970];
    if (diff < 5*60) {
        return @"刚刚";
    } else if (diff >= 5*kOneMin && diff < kOneHour) {
        NSInteger i = diff / kOneMin;
        return [NSString stringWithFormat:@"%ld分钟前", (long)i];
    } else if (diff >= kOneHour && diff < kOneDay) {
        NSInteger i = diff / kOneHour;
        return [NSString stringWithFormat:@"%ld小时前", (long)i];
    } else if (diff >= kOneDay && diff < 2*kOneDay) {
        NSString *str = [date HHmm];
        return [NSString stringWithFormat:@"昨天%@", str];
    } else if (diff >= 2*kOneDay && diff < 3*kOneDay) {
        NSString *str = [date HHmm];
        return [NSString stringWithFormat:@"前天%@", str];
    } else if (diff >= 3*kOneDay && diff < kOneYear) {
        return [date MM_dd];
    } else if (diff >= kOneYear) {
        return [date yyyy_MM_dd];
    } else {
        return [date yyyy_MM_dd];
    }
}

- (NSString *)humCountString {
    if ([self longLongValue] > kWang) {
        return [NSString stringWithFormat:@"%.1f万", [self doubleValue]/kWang];
    } else if ([self longLongValue] > kQianWang) {
        return [NSString stringWithFormat:@"%.1f千万", [self doubleValue]/kQianWang];
    } else if ([self longLongValue] > kYi) {
        return [NSString stringWithFormat:@"%.1f亿", [self doubleValue]/kYi];
    } else {
        return [self stringValue];
    }
}

- (NSString *)humRmbString {
    return [NSString stringWithFormat:@"￥%@", self];
}

- (NSString *)humSizeString {
    return [NSString stringWithFormat:@"%.2fMB", [self doubleValue]/kMB];
}

+ (BOOL)compareNumWithIgnoreNil:(NSNumber *)aNumber other:(NSNumber *)bNumber {
    return [aNumber ? aNumber : @(0) isEqualToNumber:bNumber ? bNumber : @(0)];
}

- (NSString *)humRmbUppercaseString {
    static NSArray *unitArr;
    static NSArray *uppercaseArr;
    unitArr = @[@"分", @"角", @"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    uppercaseArr = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    NSMutableString *moneyStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f", [self doubleValue]]];
    NSMutableString *chineseNumerals = [[NSMutableString alloc] init];
    
    [moneyStr deleteCharactersInRange:NSMakeRange([moneyStr rangeOfString:@"."].location, 1)];
    
    for(NSInteger i = moneyStr.length; i > 0; i--) {
        NSInteger num = [[moneyStr substringWithRange:NSMakeRange(moneyStr.length - i, 1)] integerValue];
        [chineseNumerals appendString:uppercaseArr[num]];
                                             
        if([[moneyStr substringFromIndex:moneyStr.length - i + 1] integerValue] == 0 && i != 1 && i != 2) {
            if ([unitArr[i - 1] isEqualToString:@"元"]) {
             
            } else {
                [chineseNumerals appendString:unitArr[i - 1]];
            }
            
            [chineseNumerals appendString:@"元整"];
            break;
        }
        
        [chineseNumerals appendString:unitArr[i - 1]];
    }
              
    return chineseNumerals;
}

@end
