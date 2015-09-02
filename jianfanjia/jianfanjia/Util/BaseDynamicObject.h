//
//  BaseDynamicObject.h
//  jianfanjia
//
//  Created by JYZ on 15/9/1.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDynamicObject : NSObject

@property(nonatomic, strong, readonly) NSMutableDictionary *data;

- (instancetype)init;
- (instancetype)initWith:(NSDictionary *)data;


@end
