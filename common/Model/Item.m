//
//  Item.m
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Item.h"

@implementation Item

@dynamic name;
@dynamic date;
@dynamic status;
@dynamic images;
@dynamic comment_count;

- (void)switchItemCellStatus {
    if (_itemCellStatus == ItemCellStatusClosed) {
        _itemCellStatus = ItemCellStatusExpaned;
    } else {
        _itemCellStatus = ItemCellStatusClosed;
    }
}

@end
