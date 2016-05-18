//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "TextEditCell.h"

@interface TextEditCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *twValue;

@end

@implementation TextEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.twValue setCornerRadius:5];
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
        self.twValue.attributedText = item.attrValue;
    } else {
        self.twValue.attributedText = nil;
        self.twValue.text = item.value;
    }
}

@end
