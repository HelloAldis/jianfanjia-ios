//
//  UserToData.m
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UserToData.h"
#import "User.h"

@implementation UserToData

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [User class];
}

- (id)transformedValue:(id)value {
    NSError *error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:[value data] options:0 error:&error];
    if (error) {
        DDLogError(@"user error %@", error);
    }
    return data;
}

- (id)reverseTransformedValue:(id)value {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:value options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        DDLogError(@"user error %@", error);
    }
    return [[User alloc] initWith:json];
}

@end
