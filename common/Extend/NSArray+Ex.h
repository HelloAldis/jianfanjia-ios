//
//  NSArray+Ex.h
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Ex)

- (NSArray *)map:(id (^)(id obj))fun;
- (NSString *)join:(NSString *)string;

@end
