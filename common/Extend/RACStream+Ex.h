//
//  RACStream+RACStream_Ex.h
//  jianfanjia
//
//  Created by Karos on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RACStream.h"

@interface RACStream (Ex)

- (instancetype)filterNonDigit:(BOOL (^)())block;
- (instancetype)length:(NSInteger (^)())block;

@end
