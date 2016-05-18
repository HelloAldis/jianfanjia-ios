//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "SelectionEditCell.h"

@interface SelectionEditCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *fldValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewLeft;

@end

@implementation SelectionEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)initWithItem:(EditCellItem *)item {
    [super initWithItem:item];
    if (item.attrTitle) {
        self.lblTitle.attributedText = item.attrTitle;
    } else {
        self.lblTitle.attributedText = nil;
        self.lblTitle.text = item.title;
    }
    
    if (item.attrValue) {
        self.fldValue.attributedText = item.attrValue;
    } else {
        self.fldValue.attributedText = nil;
        self.fldValue.text = item.value;
    }
    
    self.fldValue.placeholder = item.placeholder;
    self.imgView.image = item.image;
    self.imgViewLeft.constant = item.image ? 10.0 : -20;
}

- (void)onTap {
    if (self.item.itemTapBlock) {
        self.item.itemTapBlock(self.item);
    }
}

@end
