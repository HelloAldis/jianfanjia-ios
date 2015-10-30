//
//  BaseDynamicObject.h
//  jianfanjia
//
//  Created by JYZ on 15/9/1.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDynamicObject : NSObject<NSCopying>

@property(nonatomic, strong, readonly) NSMutableDictionary *data;

- (instancetype)init;
- (instancetype)initWith:(NSMutableDictionary *)data;
- (void)setObject:(id)o forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

- (BaseDynamicObject *)merge:(BaseDynamicObject *)dynamicObject;
@end
