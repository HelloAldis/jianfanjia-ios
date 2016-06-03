//
//  HomePageDesignerCell.h
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kProductAuthCellHeight 300

typedef void (^ProductAuthCellDeleteBlock)(void);

@interface ProductAuthCell : UITableViewCell

- (void)initWithProduct:(Product *)product edit:(BOOL)edit deleteBlock:(ProductAuthCellDeleteBlock)deleteBlock;

@end
