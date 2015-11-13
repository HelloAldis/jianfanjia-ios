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

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

+ (DesignerSectionCell *)sectionView {
    return [[[NSBundle mainBundle] loadNibNamed:@"DesignerSection" owner:nil options:nil] lastObject];
}



@end
