//
//  SearchUserNotification.m
//  jianfanjia
//
//  Created by Karos on 16/3/9.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "SearchDesignerNotification.h"

@implementation SearchDesignerNotification

@dynamic query;
@dynamic sort;
@dynamic search_word;
@dynamic from;
@dynamic limit;

+ (SearchDesignerNotification *)requestWithTypes:(NSArray *)types {
    SearchDesignerNotification *request = [[SearchDesignerNotification alloc] init];
    request.query = @{@"message_type":@{@"$in":types}};
    
    return request;
}

@end
