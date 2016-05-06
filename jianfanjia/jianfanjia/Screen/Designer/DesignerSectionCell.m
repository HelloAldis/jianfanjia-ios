//
//  DesignerSectionCell.m
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerSectionCell.h"

@interface DesignerSectionCell ()

@end

@implementation DesignerSectionCell

+ (DesignerSectionCell *)sectionView {
    return [[[NSBundle mainBundle] loadNibNamed:@"DesignerSection" owner:nil options:nil] lastObject];
}

@end
