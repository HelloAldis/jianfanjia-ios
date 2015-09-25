//
//  Item.h
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface Item : BaseModel

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSMutableArray *images;

@end
