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


@end
