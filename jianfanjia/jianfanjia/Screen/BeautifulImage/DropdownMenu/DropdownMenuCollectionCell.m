//
//  ItemImageCollectionCell.m
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DropdownMenuCollectionCell.h"

@interface DropdownMenuCollectionCell ()
@property (weak, nonatomic) IBOutlet UIView *background;

@end

@implementation DropdownMenuCollectionCell

- (void)awakeFromNib {
    [self.background setCornerRadius:self.background.bounds.size.height / 2];
    
    @weakify(self);
    [RACObserve(self, selected) subscribeNext:^(NSNumber *newValue) {
        @strongify(self);
        if (newValue.boolValue) {
            self.background.backgroundColor = kFinishedColor;
            [self.background setBorder:1 andColor:kFinishedColor.CGColor];
            self.lblTitle.textColor = [UIColor whiteColor];
        } else {
            self.background.backgroundColor = [UIColor whiteColor];
            [self.background setBorder:1 andColor:[UIColor whiteColor].CGColor];
            self.lblTitle.textColor = kThemeTextColor;
        }
    }];
}

@end
