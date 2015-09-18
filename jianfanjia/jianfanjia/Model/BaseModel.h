//
//  BaseModel.h
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseDynamicObject.h"

@interface BaseModel : BaseDynamicObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *final_designerid;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *cell;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *going_on;

@end
