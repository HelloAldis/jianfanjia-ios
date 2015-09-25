//
//  ProcessToData.m
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProcessToData.h"
#import "Process.h"

@implementation ProcessToData

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [Process class];
}

- (id)transformedValue:(id)value {
    NSError *error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:[value data] options:0 error:&error];
    if (error) {
        DDLogError(@"process error %@", error);
    }
    return data;
}

- (id)reverseTransformedValue:(id)value {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:value options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        DDLogError(@"process error %@", error);
    }
    return [[Process alloc] initWith:json];
}

@end
