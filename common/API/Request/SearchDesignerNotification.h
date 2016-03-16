//
//  SearchUserNotification.h
//  jianfanjia
//
//  Created by Karos on 16/3/9.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchDesignerNotification : BaseRequest

@property (nonatomic, strong) NSDictionary *query;
@property (nonatomic, strong) NSDictionary *sort;
@property (nonatomic, strong) NSString *search_word;
@property (nonatomic, strong) NSNumber *from;
@property (nonatomic, strong) NSNumber *limit;

+ (SearchDesignerNotification *)requestWithTypes:(NSArray *)types;

@end
