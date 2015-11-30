//
//  ItemCell.h
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProcessDataManager;

@interface ItemCell : UITableViewCell

- (void)initWithItem:(Item *)item withDataManager:(ProcessDataManager *)dataManager;

@end
