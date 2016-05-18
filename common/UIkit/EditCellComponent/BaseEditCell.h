//
//  SelectionEditCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCellItem.h"

@interface BaseEditCell : UITableViewCell

@property (weak, nonatomic) EditCellItem *item;

- (void)initWithItem:(EditCellItem *)item;

@end
