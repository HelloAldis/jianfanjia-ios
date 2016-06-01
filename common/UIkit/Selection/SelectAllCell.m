//
//  MultipleLineTextTableViewCell.m
//  jianfanjia
//
//  Created by Karos on 16/1/12.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "SelectAllCell.h"

@interface SelectAllCell ()
@property (weak, nonatomic) IBOutlet UISwitch *switcher;

@property (nonatomic, copy) SelectAllBlock selectAllBlock;

@end

@implementation SelectAllCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)initWithValue:(BOOL)isAll selectBlock:(SelectAllBlock)selectAllBlock {
    self.selectAllBlock = selectAllBlock;
    [self.switcher setOn:isAll];
}

- (IBAction)onTapSwitcher:(UISwitch *)sender {
    if (self.selectAllBlock) {
        self.selectAllBlock(sender.isOn);
    }
}

@end
