//
//  NSObject+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/9/1.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "NSObject+Ex.h"
#import "objc/runtime.h"

@implementation NSObject(Ex)

- (id)reverseDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setReverseDelegate:(id)delegate {
    objc_setAssociatedObject(self, @selector(reverseDelegate), delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSDictionary *)propertyNamesDictionary {
    NSMutableDictionary *propDict = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *objProperties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = objProperties[i];
        const char *propName = property_getName(property);
        
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            [propDict setObject:propertyName forKey:propertyName];
        }
    }
    free(objProperties);
    
    return [NSDictionary dictionaryWithDictionary:propDict];
}

@end
