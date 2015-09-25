//
//  BaseDynamicObject.m
//  jianfanjia
//
//  Created by JYZ on 15/9/1.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseDynamicObject.h"
#import "objc/runtime.h"

@interface BaseDynamicObject ()


@end

@implementation BaseDynamicObject

- (instancetype)init {
    if (self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (instancetype)initWith:(NSMutableDictionary *)data {
    if (self = [super init]) {
        if (data) {
            _data = data;
        } else {
            _data = [[NSMutableDictionary alloc] init];
        }
    }
    
    return self;
}

- (void)setObject:(id)o forKey:(NSString *)key {
    [[self data] setObject:o forKey:key];
}

- (id)objectForKey:(NSString *)key {
    return [[self data] objectForKey:key];
}

- (BaseDynamicObject *)merge:(BaseDynamicObject *)dynamicObject {
    if (dynamicObject && dynamicObject.data) {
        [self.data addEntriesFromDictionary:dynamicObject.data];
        return self;
    } else {
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWith:self.data];
}

#pragma mark - Getters and Setters for dynamic properties
/**
 Description: Save the properties in a dictionary.
 @param self Target
 @param _cmd A selector
 @param value The new values that will be saved in a dictionary
 */
void objSetterImp(id self, SEL _cmd, id value) {
    @try {
        NSString *selStr = NSStringFromSelector(_cmd);
        if ([[selStr substringToIndex:3] isEqualToString:@"set"])
            selStr = [selStr substringFromIndex:3];
        selStr = [[selStr substringWithoutLast:1] lowercaseFirstLetterString];
        //NAILog("model", @"setter, name = %@, value = %@", selStr, value);
        NSString *key = selStr;
        [self setObject:value forKey:key];
    }
    @catch (NSException *exception) {}
}

/**
 Description: Get the properties value by specified key.
 @param self Target
 @param _cmd A selector
 */
NSObject* objGetterImp(id self, SEL _cmd) {
    @try {
        NSString *key = NSStringFromSelector(_cmd);
   
        //NAILog("model", @"getter, name = %@", selStr);
        id obj = [self objectForKey:key];
        return obj;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

#pragma mark - Dynamic adding properties
/**
 Description: An instance method to add setter or getter method for a class.
 @param aSEL A selector
 */
+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
    NSString *selStr = NSStringFromSelector(aSEL);
    NSDictionary *propDict = [self propertyNamesDictionary];
    
    if ([propDict objectForKey:selStr]) {
        //NAILog("model", @"Add getter selector %@", selStr);
        class_addMethod([self class], aSEL, (IMP) objGetterImp, "@@:");
        return YES;
    }
    
    if ([[selStr substringToIndex:3] isEqualToString:@"set"]) {
        //NAILog("model", @"Add setter selector %@", selStr);
        class_addMethod([self class], aSEL, (IMP) objSetterImp, "v@:@");
        return YES;
        
    }
    
    return [super resolveInstanceMethod:aSEL];
}

#pragma mark - Override description method
-(NSString *)description{
    return [NSString stringWithFormat:@"%@ = %@", [super description], [self data]];
}


@end
