//
//  Item.h
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, ItemCellStatus) {
    ItemCellStatusClosed,
    ItemCellStatusExpaned,
};

@interface Item : BaseModel

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *date;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSMutableArray *images;

//辅助属性
@property(nonatomic, assign) ItemCellStatus itemCellStatus;
- (void)switchItemCellStatus;

@end
