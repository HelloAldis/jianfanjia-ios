//
//  ProductAuthPlanImageCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductAuthImageActionView.h"

extern CGFloat kInfoAuthDiplomaImageCellHeight;

@interface InfoAuthDiplomaImageCell : UITableViewCell

- (void)initWithDesigner:(Designer *)designer diploma:(NSString *)diploma isEdit:(BOOL)isEdit actionBlock:(ProductAuthImageActionViewTapBlock)actionBlock;

@end
