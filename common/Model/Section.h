//
//  Section.h
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"
@class Item;

@interface Section : BaseModel

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *start_at;
@property(nonatomic, strong) NSNumber *end_at;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSMutableArray *items;

//辅助属性
@property(nonatomic, strong) Item *latestItem;

- (Item *)itemAtIndex:(NSInteger )index;

@end
