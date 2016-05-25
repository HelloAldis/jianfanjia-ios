//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "TextEditCell.h"

#define kMaxTextDescLength 140

@interface TextEditCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *twValue;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftLength;

@end

@implementation TextEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.twValue.delegate = self;
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
    
    @weakify(self);
    [[self.twValue.rac_textSignal
      length:^NSInteger{
          return kMaxTextDescLength;
      }]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         self.twValue.text = value;
         self.item.value = value;
         if (item.attrValue) {
             self.item.attrValue.mutableString.string = value;
         }

         self.lblLeftLength.text = [NSString stringWithFormat:@"%@/%@", @(kMaxTextDescLength - value.length), @(kMaxTextDescLength)];
         
         if (self.item.itemEditBlock) {
             self.item.itemEditBlock(self.item, EditCellItemEditTypeChange);
         }
     }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.item.itemEditBlock) {
        self.item.itemEditBlock(self.item, EditCellItemEditTypeBegin);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.item.itemEditBlock) {
        self.item.itemEditBlock(self.item, EditCellItemEditTypeEnd);
    }
}


@end
