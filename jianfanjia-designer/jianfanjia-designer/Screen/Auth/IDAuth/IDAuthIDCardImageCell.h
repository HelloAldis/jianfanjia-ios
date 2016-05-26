//
//  ProductAuthPlanImageCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardImageCell.h"

extern CGFloat kIDAuthIDCardImageCellHeight;

@interface IDAuthIDCardImageCell : UITableViewCell

- (void)initWithDesigner:(Designer *)designer actionBlock:(CardImageCellActionBlock)actionBlock;
- (void)initWithTeam:(Team *)team actionBlock:(CardImageCellActionBlock)actionBlock;

@end
