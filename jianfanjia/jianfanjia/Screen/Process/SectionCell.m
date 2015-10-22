//
//  SectionCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "SectionCell.h"
#import "SectionView.h"
#import "Section.h"

@implementation SectionCell

- (void)awakeFromNib {
    CGFloat width = 0;
    CGFloat height = 0;
    Process *process= [ProcessBusiness defaultProcess];
    for (int i = 0; i < [process sections].count; i++) {
        SectionView *view = [SectionView sectionView];
        view.frame = CGRectOffset(view.frame, view.frame.size.width * i , 0);
        [self.scrollView addSubview:view];
        width = view.frame.size.width;
        height = view.frame.size.height;
        
        if (i == 0) {
            view.leftLine.hidden = YES;
        } else if (i == ([process sections].count - 1)) {
            view.rightLine.hidden = YES;
        }
        
        Section *section = [process sectionAtIndex:i];
        view.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"section_%d_%@", i, section.status]];
        view.nameLabel.text = [ProcessBusiness nameForKey:section.name];
    }
    
    self.scrollView.contentSize = CGSizeMake(width * [process sections].count, height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
