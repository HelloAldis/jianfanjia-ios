//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "FieldEditCell.h"

@interface FieldEditCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *fldValue;

@end

@implementation FieldEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.fldValue.delegate = self;
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
    self.fldValue.keyboardType = item.keyboard;
    
    if (item.length == 0) {
        item.length = NSIntegerMax;
    }
    
    @weakify(self);
    [[[self.fldValue rac_textSignal]
      length:^NSInteger {
          return item.length;
      }]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         self.fldValue.text = value;
         self.item.value = value;
         if (item.attrValue) {
             self.item.attrValue.mutableString.string = value;
         }
         if (self.item.itemEditBlock) {
             self.item.itemEditBlock(self.item, EditCellItemEditTypeChange);
         }
     }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.item.itemEditBlock) {
        self.item.itemEditBlock(self.item, EditCellItemEditTypeBegin);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField; {
    if (self.item.itemEditBlock) {
        self.item.itemEditBlock(self.item, EditCellItemEditTypeEnd);
    }
}

@end
