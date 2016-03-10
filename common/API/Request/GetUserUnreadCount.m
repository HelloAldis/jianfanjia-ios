//
//  GetUserUnreadCount.m
//  jianfanjia
//
//  Created by Karos on 16/3/10.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "GetUserUnreadCount.h"

@implementation GetUserUnreadCount

@dynamic query_array;

+ (GetUserUnreadCount *)requestWithTypes:(NSArray *)types {
    GetUserUnreadCount *request = [[GetUserUnreadCount alloc] init];
    request.query_array = types;
    
    return request;
}

@end
