//
//  NSDate+Ex.h
//  jianfanjia
//
//  Created by KindAzrael on 15/11/12.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Ex)

- (NSString *)yyyy_MM_dd;

- (NSString *)HHmm;
- (NSString *)MM_dd;
+ (NSString *)yyyy_MM_dd:(NSNumber *)timeInterval;
- (NSString *)yyyy_MM_dd_HH_mm;
+ (NSString *)yyyy_MM_dd_HH_mm:(NSNumber *)timeInterval;

@end
