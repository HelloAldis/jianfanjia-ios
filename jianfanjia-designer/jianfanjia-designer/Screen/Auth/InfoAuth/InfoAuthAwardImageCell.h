//
//  ProductAuthPlanImageCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductAuthImageActionView.h"

#define kInfoAuthAwardImageCellHeight 416

@interface InfoAuthAwardImageCell : UITableViewCell

- (void)initWithDesigner:(Designer *)designer award:(AwardDetail *)award isEdit:(BOOL)isEdit actionBlock:(ProductAuthImageActionViewTapBlock)actionBlock;

@end
