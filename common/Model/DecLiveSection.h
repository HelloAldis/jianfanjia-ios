//
//  Item.h
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface DecLiveSection : BaseModel

@property(nonatomic, strong) NSString *_id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *date;
@property(nonatomic, strong) NSArray *images;

@end
