//
//  RACStream+RACStream_Ex.m
//  jianfanjia
//
//  Created by Karos on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RACStream+Ex.h"

@implementation RACStream (Ex)

- (instancetype)filterNonDigit:(BOOL (^)())block {
    NSCParameterAssert(block != nil);
    
    return [[self map:^(NSString *value) {
        if (block()) {
            return [value stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];;
        }
        
        return value;
        
    }] setNameWithFormat:@"[%@] -filterNonDigit:", self.name];
}

- (instancetype)filterNonSpace:(BOOL (^)())block {
    NSCParameterAssert(block != nil);
    
    return [[self map:^(NSString *value) {
        if (block()) {
            return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
        }
        
        return value;
        
    }] setNameWithFormat:@"[%@] -filterNonDigit:", self.name];
}

- (instancetype)length:(NSInteger (^)())block {
    NSCParameterAssert(block != nil);
    
    return [[self map:^(NSString *value) {
        NSInteger length = block();
        if (value.length > length) {
            return [value substringToIndex:length];
        }
        
        return value;
        
    }] setNameWithFormat:@"[%@] -length:", self.name];
}

@end
