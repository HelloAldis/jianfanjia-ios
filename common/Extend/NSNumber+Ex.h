//
//  NSNumber+Ex.h
//  jianfanjia
//
//  Created by JYZ on 15/11/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Ex)

- (NSString *)humDateString;
- (NSString *)humCountString;
- (NSString *)humSizeString;
- (NSString *)humRmbString;
+ (BOOL)compareNumWithIgnoreNil:(NSNumber *)aNumber other:(NSNumber *)bNumber;

@end
