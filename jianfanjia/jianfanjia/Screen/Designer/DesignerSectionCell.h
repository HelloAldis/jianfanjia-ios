//
//  DesignerSectionCell.h
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignerSectionCell : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnProduct;

+ (DesignerSectionCell *)sectionView;

@end
