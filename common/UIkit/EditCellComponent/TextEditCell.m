//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "TextEditCell.h"

CGFloat kTextEditCellHeight;

#define kMaxTextDescLength 140

@interface TextEditCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *twValue;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftLength;

@end

@implementation TextEditCell

+ (void)initialize {
    if ([self class] == [TextEditCell class]) {
        CGSize constrainedSize = CGSizeMake(kScreenWidth - 35  , 9999);
        CGSize size = [NSString sizeWithConstrainedSize:constrainedSize font:[UIFont systemFontOfSize:14.0] maxLength:kMaxTextDescLength];
        kTextEditCellHeight = size.height + 90;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.twValue.delegate = self;
    
    @weakify(self);
    [self.twValue.rac_textSignal subscribeNext:^(NSString *value) {
        @strongify(self);
        [self updateValue:value];
    }];
}

- (void)initWithItem:(EditCellItem *)item {
    [super initWithItem:item];
    if (item.attrTitle) {
        self.lblTitle.attributedText = item.attrTitle;
    } else {
        self.lblTitle.attributedText = nil;
        self.lblTitle.text = item.title;
    }
    
    [self initValue];
    self.twValue.placeholder = item.allowsEdit ? item.placeholder : @"";
    
    self.userInteractionEnabled = item.allowsEdit;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.item.itemEditBlock) {
        self.item.itemEditBlock(self.item, EditCellItemEditTypeBegin);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL flag = YES;
    NSString *curStr = textView.text;
    NSInteger len = curStr.length +  (text.length - range.length);
    NSInteger lenDelta = len - kMaxTextDescLength;
    NSInteger replaceToIndex = text.length - lenDelta;
    
    if (lenDelta > 0 && replaceToIndex < text.length) {
        NSString *replaceStr = [text substringToIndex:replaceToIndex];
        
        NSString *updatedStr = [curStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:replaceStr];
        flag = NO;
        [self updateValue:updatedStr];
        [self initValue];
    }

    return flag;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.item.itemEditBlock) {
        self.item.itemEditBlock(self.item, EditCellItemEditTypeEnd);
    }
}

- (void)initValue {
    if (self.item.attrValue) {
        self.twValue.attributedText = self.item.attrValue;
        self.item.value = self.item.attrValue.string;
    } else {
        self.twValue.attributedText = nil;
        self.twValue.text = self.item.value;
    }
    
    [self updateLeftLength:self.item.value];
}

- (void)updateValue:(NSString *)value {
    self.item.value = value ? value : @"";
    if (self.item.attrValue) {
        self.item.attrValue.mutableString.string = value;
    }
    
    if (self.item.itemEditBlock) {
        self.item.itemEditBlock(self.item, EditCellItemEditTypeChange);
    }
    
    [self updateLeftLength:value];
}

- (void)updateLeftLength:(NSString *)value {
    self.lblLeftLength.text = [NSString stringWithFormat:@"%@/%@", @(kMaxTextDescLength - value.length), @(kMaxTextDescLength)];
}

@end
