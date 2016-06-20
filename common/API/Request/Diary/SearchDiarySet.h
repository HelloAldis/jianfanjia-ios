//
//  AddDiarySet.h
//  jianfanjia
//
//  Created by Karos on 16/6/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchDiarySet : BaseRequest

@property (nonatomic, strong) NSDictionary *query;
@property (nonatomic, strong) NSDictionary *sort;
@property (nonatomic, strong) NSNumber *from;
@property (nonatomic, strong) NSNumber *limit;

@end
