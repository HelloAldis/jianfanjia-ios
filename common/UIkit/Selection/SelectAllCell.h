//
//  MultipleLineTextTableViewCell.h
//  jianfanjia
//
//  Created by Karos on 16/1/12.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectAllBlock)(BOOL isAll);

@interface SelectAllCell : UITableViewCell

- (void)initWithValue:(BOOL)isAll selectBlock:(SelectAllBlock)selectAllBlock;

@end
