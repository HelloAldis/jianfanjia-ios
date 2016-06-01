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
    
    @weakify(self);
    [[self.fldValue rac_textSignal] subscribeNext:^(NSString *value) {
        @strongify(self);
        [self updateValue:value];
    }];
}

- (void)initWithItem:(EditCellItem *)item {
    [super initWithItem:item];
    
    if (self.item.attrTitle) {
        self.lblTitle.attributedText = self.item.attrTitle;
    } else {
        self.lblTitle.attributedText = nil;
        self.lblTitle.text = self.item.title;
    }
    
    [self initValue];
    
    self.fldValue.placeholder = item.placeholder;
    self.fldValue.keyboardType = item.keyboard;
    
    if (item.length == 0) {
        item.length = NSIntegerMax;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.item.itemEditBlock) {
        self.item.itemEditBlock(self.item, EditCellItemEditTypeBegin);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL flag = YES;
    NSString *curStr = textField.text;
    NSInteger len = curStr.length +  (string.length - range.length);
    NSInteger lenDelta = len - self.item.length;
    
    if (lenDelta > 0) {
        NSString *replaceStr = [string substringToIndex:string.length - lenDelta];
        
        NSString *updatedStr = [curStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:replaceStr];
        flag = NO;
        [self updateValue:updatedStr];
        [self initValue];
    }
    
    return flag;
}

- (void)textFieldDidEndEditing:(UITextField *)textField; {
    if (self.item.itemEditBlock) {
        self.item.itemEditBlock(self.item, EditCellItemEditTypeEnd);
    }
}

- (void)initValue {
    if (self.item.attrValue) {
        self.fldValue.attributedText = self.item.attrValue;
        self.item.value = self.item.attrValue.string;
    } else {
        self.fldValue.attributedText = nil;
        self.fldValue.text = self.item.value;
    }
}

- (void)updateValue:(NSString *)value {
    self.item.value = value ? value : @"";
    if (self.item.attrValue) {
        self.item.attrValue.mutableString.string = value;
    }
    
    if (self.item.itemEditBlock) {
        self.item.itemEditBlock(self.item, EditCellItemEditTypeChange);
    }
}

@end
