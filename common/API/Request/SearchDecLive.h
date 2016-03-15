//
//  SearchDecLive.h
//  jianfanjia
//
//  Created by Karos on 16/3/14.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchDecLive : BaseRequest

@property (nonatomic, strong) NSDictionary *query;
@property (nonatomic, strong) NSNumber *from;
@property (nonatomic, strong) NSNumber *limit;

@end
