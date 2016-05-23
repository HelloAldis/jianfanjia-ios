//
//  ProductAuthPlanImageCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kProductAuthImpressionImageCellHeight 466

@interface ProductAuthImpressionImageCell : UITableViewCell

- (void)initWithProduct:(Product *)product image:(ProductImage *)image;

@end
