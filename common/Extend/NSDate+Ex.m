//
//  NSDate+Ex.m
//  jianfanjia
//
//  Created by KindAzrael on 15/11/12.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "NSDate+Ex.h"

@implementation NSDate (Ex)

- (long long)getLongMilSecond {
    return [@([self timeIntervalSince1970] * 1000) longLongValue];
}

- (NSString *)yyyy_Nian_MM_Yue_dd_Ri_HH_mm {
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    return [formate stringFromDate:self];
}

- (NSString *)yyyy_Nian_MM_Yue_dd_Ri {
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy年MM月dd日"];
    return [formate stringFromDate:self];
}

- (NSString *)yyyy_MM_dd {
  NSDateFormatter *formate = [[NSDateFormatter alloc] init];
  [formate setDateFormat:@"yyyy-MM-dd"];
  return [formate stringFromDate:self];
}

- (NSString *)HHmm {
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"HH:mm"];
    return [formate stringFromDate:self];
}

- (NSString *)MM_dd {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    return [formatter stringFromDate:self];
}

- (NSString *)yyyy_MM_dd_HH_mm {
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formate stringFromDate:self];
}

- (NSString *)M_dot_dd {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M.dd"];
    return [formatter stringFromDate:self];
}

+ (NSString *)yyyy_Nian_MM_Yue_dd_Ri_HH_mm:(NSNumber *)timeInterval {
    return [[NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue / 1000] yyyy_Nian_MM_Yue_dd_Ri_HH_mm];
}

+ (NSString *)yyyy_MM_dd:(NSNumber *)timeInterval {
    return [[NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue / 1000] yyyy_MM_dd];
}

+ (NSString *)yyyy_MM_dd_HH_mm:(NSNumber *)timeInterval {
    return [[NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue / 1000] yyyy_MM_dd_HH_mm];
}

+ (NSString *)M_dot_dd:(NSNumber *)timeInterval {
    return [[NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue / 1000] M_dot_dd];
}

@end
