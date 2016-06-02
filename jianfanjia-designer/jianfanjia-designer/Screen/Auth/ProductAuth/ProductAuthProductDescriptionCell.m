//
//  ProductAuthProductDescriptionCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductAuthProductDescriptionCell.h"

#define kMaxProductDescLength 140

CGFloat kProductAuthProductDescriptionCellHeight;

@interface ProductAuthProductDescriptionCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblLeftLength;

@property (strong, nonatomic) Product *product;

@end

@implementation ProductAuthProductDescriptionCell

+ (void)initialize {
    if ([self class] == [ProductAuthProductDescriptionCell class]) {
        CGSize constrainedSize = CGSizeMake(kScreenWidth - 50  , 9999);
        CGSize size = [NSString sizeWithConstrainedSize:constrainedSize font:[UIFont systemFontOfSize:14.0] maxLength:kMaxProductDescLength];
        kProductAuthProductDescriptionCellHeight = size.height + 90;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tvDesc.delegate = self;
    
    @weakify(self);
    [self.tvDesc.rac_textSignal subscribeNext:^(NSString *value) {
         @strongify(self);
         [self updateValue];
     }];
}

- (void)initWithProduct:(Product *)product {
    self.product = product;
    self.tvDesc.text = product.product_description;
    self.tvDesc.placeholder = @"请输入";
    [self updateValue];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL flag = YES;
    NSString *curStr = textView.text;
    NSInteger len = curStr.length +  (text.length - range.length);
    NSInteger lenDelta = len - kMaxProductDescLength;
    
    if (lenDelta > 0) {
        NSString *replaceStr = [text substringToIndex:text.length - lenDelta];
        
        NSString *updatedStr = [curStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:replaceStr];
        textView.text = updatedStr;
        flag = NO;
        [self updateValue];
    }
    
    return flag;
}

- (void)updateValue {
    NSString *value = self.tvDesc.text;
    
    self.product.product_description = value;
    self.lblLeftLength.text = [NSString stringWithFormat:@"%@/%@", @(kMaxProductDescLength - value.length), @(kMaxProductDescLength)];
}

@end
