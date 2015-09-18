//
//  SectionCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "SectionCell.h"
#import "SectionView.h"
#import "Business.h"

@implementation SectionCell

- (void)awakeFromNib {
    CGFloat width = 0;
    CGFloat height = 0;
    for (int i = 0; i < [Business sectionCount]; i++) {
        SectionView *view = [SectionView sectionView];
        view.frame = CGRectOffset(view.frame, view.frame.size.width * i , 0);
        [self.scrollView addSubview:view];
        width = view.frame.size.width;
        height = view.frame.size.height;
    }
    
    self.scrollView.contentSize = CGSizeMake(width * [Business sectionCount], height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
