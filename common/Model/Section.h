//
//  Section.h
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"
@class Item;
@class Ys;
@class Schedule;

@interface Section : BaseModel

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *label;
@property(nonatomic, strong) NSNumber *start_at;
@property(nonatomic, strong) NSNumber *end_at;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSMutableArray *items;

//不动态属性
@property(nonatomic, strong) Ys *ys;
@property(nonatomic, strong) Schedule *schedule;

//辅助属性
@property(nonatomic, strong) Item *latestItem;

- (Item *)itemAtIndex:(NSInteger )index;
- (Item *)itemForName:(NSString *)name;

@end
