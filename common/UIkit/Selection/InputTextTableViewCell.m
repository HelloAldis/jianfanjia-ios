//
//  MultipleLineTextTableViewCell.m
//  jianfanjia
//
//  Created by Karos on 16/1/12.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "InputTextTableViewCell.h"

@interface InputTextTableViewCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UITextField *fldVal;

@property (copy, nonatomic) InputTextEndBlock inputEndBlock;

@end

@implementation InputTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    [[[self.fldVal rac_textSignal]
      length:^NSInteger {
          return 6;
      }]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         self.fldVal.text = value;
         
         if (self.inputEndBlock) {
             self.inputEndBlock(value);
         }
     }];
}

- (void)initWithTitle:(NSString *)title value:(NSString *)value inputEndBlock:(InputTextEndBlock)inputEndBlock {
    self.lblText.text = title;
    self.fldVal.text = value;
    self.inputEndBlock = inputEndBlock;
}

@end
