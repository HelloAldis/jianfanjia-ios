//
//  ProductAuthPlanImageCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardImageCell.h"

#define kIDAuthIDCardImageCellHeight 150

@interface IDAuthIDCardImageCell : UITableViewCell

- (void)initWithDesigner:(Designer *)designer actionBlock:(CardImageCellActionBlock)actionBlock;

@end
