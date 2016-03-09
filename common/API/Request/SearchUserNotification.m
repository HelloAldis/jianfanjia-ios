//
//  SearchUserNotification.m
//  jianfanjia
//
//  Created by Karos on 16/3/9.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "SearchUserNotification.h"

@implementation SearchUserNotification

@dynamic query;
@dynamic sort;
@dynamic search_word;
@dynamic from;
@dynamic limit;

+ (SearchUserNotification *)requestWithTypes:(NSArray *)types {
    SearchUserNotification *request = [[SearchUserNotification alloc] init];
    request.query = @{@"message_type":@{@"$in":types}};
    
    return request;
}

@end
