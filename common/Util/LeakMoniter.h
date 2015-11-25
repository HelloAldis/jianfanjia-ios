//
//  LeakMoniter.h
//  SparkPay
//
//  Created by Az on 15/5/4.
//  Copyright (c) 2015年 Capital One Services, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeakMoniter : NSObject

+ (void)start;
+ (void)end;

@end
