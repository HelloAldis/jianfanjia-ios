//
//  QueryProduct.h
//  jianfanjia
//
//  Created by JYZ on 15/11/6.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface QueryProduct : BaseRequest

@property (strong, nonatomic) NSDictionary *query;
@property (assign, nonatomic) NSNumber *from;
@property (assign, nonatomic) NSNumber *limit;

@end
