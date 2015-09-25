//
//  Section.h
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface Section : BaseModel

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *start_at;
@property(nonatomic, strong) NSNumber *end_at;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSMutableArray *items;

@end
