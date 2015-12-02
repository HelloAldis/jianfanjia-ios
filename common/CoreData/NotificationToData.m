//
//  NotificationToData.m
//  jianfanjia
//
//  Created by JYZ on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "NotificationToData.h"

@implementation NotificationToData

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSMutableDictionary class];
}

- (id)transformedValue:(id)value {
    NSError *error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:[value data] options:0 error:&error];
    if (error) {
        DDLogError(@"notification error %@", error);
    }
    return data;
}

- (id)reverseTransformedValue:(id)value {
    NSError *error = nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:value options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        DDLogError(@"notification error %@", error);
    }
    
    return json;
}

@end
