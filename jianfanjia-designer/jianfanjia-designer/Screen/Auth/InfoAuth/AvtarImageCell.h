//
//  SelectionEditCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAvtarImageCellHeight 100

typedef void (^AvtarImageCellUpdateBlock)(NSString *imageid);

@interface AvtarImageCell : UITableViewCell

- (void)initWithDesigner:(Designer *)designer allowsEdit:(BOOL)allowsEdit updateBlock:(AvtarImageCellUpdateBlock)updateBlock;

@end
