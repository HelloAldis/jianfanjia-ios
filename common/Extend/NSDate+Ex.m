//
//  NSDate+Ex.m
//  jianfanjia
//
//  Created by KindAzrael on 15/11/12.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "NSDate+Ex.h"

@implementation NSDate (Ex)

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

+ (NSString *)yyyy_MM_dd:(NSNumber *)timeInterval {
    return [[NSDate dateWithTimeIntervalSince1970:timeInterval.longValue / 1000] yyyy_MM_dd];
}

- (NSString *)yyyy_MM_dd_HH_mm {
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formate stringFromDate:self];
}

+ (NSString *)yyyy_MM_dd_HH_mm:(NSNumber *)timeInterval {
    return [[NSDate dateWithTimeIntervalSince1970:timeInterval.longValue / 1000] yyyy_MM_dd_HH_mm];
}

@end
