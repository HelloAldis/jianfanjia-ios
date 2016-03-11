//
//  SearchUserComment.h
//  jianfanjia
//
//  Created by Karos on 16/3/11.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchUserComment : BaseRequest

@property (nonatomic, strong) NSDictionary *query;
@property (nonatomic, strong) NSDictionary *sort;
@property (nonatomic, strong) NSString *search_word;
@property (nonatomic, strong) NSNumber *from;
@property (nonatomic, strong) NSNumber *limit;

@end
