//
//  NSDictionary+Ex.h
//  jianfanjia
//
//  Created by Karos on 15/12/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Ex)

- (NSMutableArray *)sortedKeyWithOrder:(BOOL)ascend;
- (NSMutableArray *)sortedValueWithOrder:(BOOL)ascend;

@end
