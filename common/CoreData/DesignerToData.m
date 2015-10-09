//
//  DesignerToData.m
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerToData.h"
#import "Designer.h"

@implementation DesignerToData

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [Designer class];
}

- (id)transformedValue:(id)value {
    NSError *error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:[value data] options:0 error:&error];
    if (error) {
        DDLogError(@"Designer error %@", error);
    }
    return data;
}

- (id)reverseTransformedValue:(id)value {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:value options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        DDLogError(@"Designer error %@", error);
    }
    return [[Designer alloc] initWith:json];
}

@end
