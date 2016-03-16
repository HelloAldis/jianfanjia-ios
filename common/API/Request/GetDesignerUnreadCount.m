//
//  GetUserUnreadCount.m
//  jianfanjia
//
//  Created by Karos on 16/3/10.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "GetDesignerUnreadCount.h"

@implementation GetDesignerUnreadCount

@dynamic query_array;

+ (GetDesignerUnreadCount *)requestWithTypes:(NSArray *)types {
    GetDesignerUnreadCount *request = [[GetDesignerUnreadCount alloc] init];
    request.query_array = types;
    
    return request;
}

@end
