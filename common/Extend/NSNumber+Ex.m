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
    NSString *rmbStr = [self stringValue];
    NSMutableString *rmbUppercase = [[NSMutableString alloc] init];
    NSInteger len = rmbStr.length;
    
    for (NSInteger i = 0; i < len; i++) {
        NSInteger numth = len - i;

        [rmbUppercase appendString:[self rmbNumToUppercase:@([[rmbStr substringWithRange:NSMakeRange(i, 1)] integerValue])]];
        [rmbUppercase appendString:[self rmbUnitToUppercase:@(numth)]];
    }
    
    return [NSString stringWithFormat:@"￥%@元", rmbUppercase];
}

- (NSString *)rmbNumToUppercase:(NSNumber *)num {
    NSString *str = @"";
    switch (num.intValue) {
        case 0:
            str = @"零";
            break;
        case 1:
            str = @"壹";
            break;
        case 2:
            str = @"贰";
            break;
        case 3:
            str = @"叁";
            break;
        case 4:
            str = @"肆";
            break;
        case 5:
            str = @"伍";
            break;
        case 6:
            str = @"陆";
            break;
        case 7:
            str = @"柒";
            break;
        case 8:
            str = @"捌";
            break;
        case 9:
            str = @"玖";
            break;
            
        default:
            break;
    }
    
    return str;
}

- (NSString *)rmbUnitToUppercase:(NSNumber *)num {
    NSString *str = @"";
    switch (num.intValue) {
        case 2:
            str = @"拾";
            break;
        case 3:
            str = @"佰";
            break;
        case 4:
            str = @"仟";
            break;
        case 5:
            str = @"万";
            break;
        case 9:
            str = @"亿";
            break;
            
        default:
            break;
    }
    
    return str;
}

@end
