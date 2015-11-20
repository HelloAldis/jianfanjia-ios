//
//  PriceItem.h
//  jianfanjia
//
//  Created by Karos on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface PriceItem : BaseModel

@property(nonatomic, strong) NSString *_id;
@property(nonatomic, strong) NSString *item;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSNumber *price;

@end
