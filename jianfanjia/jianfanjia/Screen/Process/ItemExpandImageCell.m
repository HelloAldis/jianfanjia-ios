//
//  ItemCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ItemExpandImageCell.h"

@interface ItemExpandImageCell ()

@property (weak, nonatomic) IBOutlet UIView *statusLine1;
@property (weak, nonatomic) IBOutlet UIView *statusLine2;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;


@property (weak, nonatomic) Process *process;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (assign, nonatomic) NSInteger itemIndex;

@end

@implementation ItemExpandImageCell

#pragma mark - life cycle
- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - UI

- (void)initUIWith:(Process *)process sectionIndex:(NSInteger )sectionIndex itemIndex:(NSInteger)itemIndex {
    self.process = process;
    self.sectionIndex = sectionIndex;
    self.itemIndex = itemIndex;
    
//    Section *section = [process sectionAtIndex:self.sectionIndex];
//    Item *item = [section itemAtIndex:self.itemIndex];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
