//
//  ProductAuthPlanImageCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductAuthImageActionView.h"

#define kInfoAuthDiplomaImageCellHeight 316

@interface InfoAuthDiplomaImageCell : UITableViewCell

- (void)initWithDesigner:(Designer *)designer diploma:(NSString *)diploma actionBlock:(ProductAuthImageActionViewTapBlock)actionBlock;

@end