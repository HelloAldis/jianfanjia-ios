//
//  GetUserUnreadCount.h
//  jianfanjia
//
//  Created by Karos on 16/3/10.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface GetUserUnreadCount : BaseRequest

@property (nonatomic, strong) NSArray *query_array;

+ (GetUserUnreadCount *)requestWithTypes:(NSArray *)types;

@end
