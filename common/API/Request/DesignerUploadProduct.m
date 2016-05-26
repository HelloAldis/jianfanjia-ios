//
//  SearchPrettyImage.m
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerUploadProduct.h"

@interface DesignerUploadProduct ()

@end

@implementation DesignerUploadProduct

- (id)initWithProduct:(Product *)product {
    if (self = [super init]) {
        [self merge:product];
    }
    
    return self;
}

- (void)setObject:(id)o forKey:(NSString *)key {
    if ([@"product_description" isEqualToString:key]) {
        [[self data] setObject:o forKey:@"description"];
    } else {
        [[self data] setObject:o forKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    if ([@"product_description" isEqualToString:key]) {
        return [[self data] objectForKey:@"description"];
    } else {
        return [[self data] objectForKey:key];
    }
}

@end
